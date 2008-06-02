/*
Copyright (c) 2007 Daniel Dura

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/		

package com.adobe.services.twitter
{
	import mx.collections.ArrayCollection;
	import com.adobe.services.twitter.requests.TwitterFriendsTimelineRequest;
	import flash.events.Event;
	import com.adobe.services.twitter.events.TwitterResponseEvent;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.adobe.services.twitter.events.StatusUpdateEvent;
	
	public class TwitterFriendsTimeline extends EventDispatcher
	{
		public var statuses:ArrayCollection;

		private var twitter:Twitter;
		private var _userId:String;
		private var _autoUpdate:Boolean;
		private var _autoUpdateTimer:Timer;
		
		public var pendingRequest:Boolean;
		public var autoUpdateInterval:int = 30000; //num milleseconds between updates		

		public function TwitterFriendsTimeline( twitter:Twitter, userId:String )
		{
			statuses = new ArrayCollection();
			
			this.twitter = twitter;
			_userId = userId;
			
			this.twitter.addEventListener( Event.CONNECT, handle_connect );
		}
		
		public function get userId():String
		{
			return _userId;
		}
		
		public function refreshTimeline():void
		{
			if( twitter.connected && !twitter.pendingRequest )
			{
				var request:TwitterFriendsTimelineRequest = new TwitterFriendsTimelineRequest( twitter, _userId );
					request.addEventListener( TwitterResponseEvent.RESPONSE, handle_friendsTimelineResponse );
					request.send();
			}
		}
		
		private function handle_connect( event:Event ):void
		{
			if( autoUpdate ) startAutoUpdate();
		}
		
		private function handle_friendsTimelineResponse( event:TwitterResponseEvent ):void
		{
			if( event.success )
			{
				var response:Array = event.data as Array;
				
				for( var i:int = 0; i < response.length; i++ )
				{
					var s:TwitterStatus = TwitterStatus( response[i] );
										
					if( !statuses.source.some( function( item:TwitterStatus, index:int, array:Array ):Boolean
					{
						return item.id == s.id;
					} ) )
					{
						statuses.addItemAt( s, 0 );
						dispatchEvent( new StatusUpdateEvent( StatusUpdateEvent.FRIEND_STATUS_UPDATE, s ) );
					}
				}
			}
		}
		
		public function set autoUpdate( value:Boolean ):void
		{
			_autoUpdate = value;
			
			if( value )
				startAutoUpdate();
			else
				stopAutoUpdate();
		}
		
		public function get autoUpdate():Boolean
		{
			return _autoUpdate;
		}		
		
		private function startAutoUpdate():void
		{
			if( _autoUpdateTimer )
				_autoUpdateTimer.stop();

			_autoUpdateTimer = new Timer( autoUpdateInterval );
			_autoUpdateTimer.addEventListener( TimerEvent.TIMER, handle_autoUpdateTimer );
			_autoUpdateTimer.start();
			
			refreshTimeline();
		}
		
		private function stopAutoUpdate():void
		{
			_autoUpdateTimer.stop();
			_autoUpdateTimer.removeEventListener( TimerEvent.TIMER, handle_autoUpdateTimer );
		}
		
		private function handle_autoUpdateTimer( event:TimerEvent ):void
		{
			refreshTimeline();
		}		
		
		
	}
}