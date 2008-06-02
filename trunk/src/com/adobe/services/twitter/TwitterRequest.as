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
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.events.EventDispatcher;
	import com.adobe.services.twitter.events.TwitterResponseEvent;
	import flash.net.URLRequest;
	import mx.utils.Base64Encoder;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import mx.utils.URLUtil;
	import flash.net.URLRequestHeader;
	//import com.adobe.peep.views.UsersTile;
	
	public class TwitterRequest extends EventDispatcher
	{
		protected var twitter:Twitter;
		protected var statusType:String;
		protected var loader:URLLoader;
		protected var userId:String;
		
		private var sending:Boolean;
		
		public function TwitterRequest( twitter:Twitter, statusType:String, userId:String = null )
		{
			this.twitter = twitter;
			this.statusType = statusType;
			this.userId = userId;
		}

		public function send():void
		{
			if( !sending )
			{
				var request:URLRequest = createRequest( statusType );
				
			 	loader = new URLLoader();
				loader.addEventListener( Event.COMPLETE, handle_requestSuccess );
				
				loader.addEventListener( IOErrorEvent.IO_ERROR, handle_requestFailure );
				loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, handle_requestFailure );
				
				sending = true;
				twitter.pendingRequest = true;
				loader.load( request );
			}
		}
		
		protected function createRequest( statusType:String ):URLRequest
		{
			var encoder:Base64Encoder = new Base64Encoder();
				encoder.encode( twitter.username + ":" + twitter.password );
				
			var authHeader:URLRequestHeader = new URLRequestHeader( "AUTHORIZATION", "Basic " + encoder.drain() );
			var ur:URLRequest = new URLRequest();
				ur.url = "http://twitter.com/statuses/" + statusType + (userId ? "/" + userId : "") + ".xml";
				ur.useCache = false;
				ur.requestHeaders = [ authHeader ];
				
			return ur;
		}
		
		private function handle_requestSuccess( event:Event ):void
		{
			sending = false;
			twitter.pendingRequest = false;
			dispatchEvent( new TwitterResponseEvent( true, parseResponse( new XML(loader.data) ) ) );
		}
		
		private function handle_requestFailure( event:Event ):void
		{
			sending = false;
			twitter.pendingRequest = false;
			dispatchEvent( new TwitterResponseEvent( false ) );
		}
		
		protected function parseResponse( data:XML ):*
		{
			//To be overridden by base classes;
		}
		
	}
}