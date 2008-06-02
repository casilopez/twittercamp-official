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
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import mx.utils.Base64Encoder;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.events.SecurityErrorEvent;
	import com.adobe.services.twitter.requests.TwitterFriendsRequest;
	import com.adobe.services.twitter.events.TwitterResponseEvent;
	import mx.collections.ArrayCollection;
	import com.adobe.services.twitter.requests.TwitterFriendsTimelineRequest;
	import com.adobe.services.twitter.requests.TwitterStatusUpdate;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	
	[Event(name="friendStatusUpdate", type="mx.events.Event")]
	
	[Bindable]
	public class Twitter extends EventDispatcher
	{
		public var connected:Boolean;
		
		public var username:String;
		public var password:String;
		
		public var friends:ArrayCollection;
		public var followers:ArrayCollection;
		public var friendsTimeline:TwitterFriendsTimeline;
		public var pendingRequest:Boolean;
				
		private var _autoUpdate:Boolean;
		private var _autoUpdateTimer:Timer;
		private var loader:URLLoader;
				
		public function Twitter()
		{
			initialize();
		}
		
		public function updateStatus( status:String ):void
		{
			var request:TwitterStatusUpdate = new TwitterStatusUpdate( this, status );
				request.addEventListener( TwitterResponseEvent.RESPONSE, handle_statusUpdateResponse );
				request.send();
		}
		
		public function handle_statusUpdateResponse( event:TwitterResponseEvent ):void
		{
		}
		
		public function login( username:String, password:String ):void
		{
			initialize();
			
			this.username = username;
			this.password = password;
			
			var request:TwitterFriendsRequest = new TwitterFriendsRequest( this );
				request.addEventListener( TwitterResponseEvent.RESPONSE, handle_loginResponse );
				request.send();
		}
		
		private function handle_loginResponse( event:TwitterResponseEvent ):void
		{
			connected = event.success;

			dispatchEvent( new Event( Event.CONNECT ) );
		}
		
		private function initialize():void
		{
			connected = false;
			
			friends = new ArrayCollection();
			followers = new ArrayCollection();
			friendsTimeline = new TwitterFriendsTimeline( this, username );
		}
		
	}
}