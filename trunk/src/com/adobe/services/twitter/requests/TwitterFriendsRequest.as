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

package com.adobe.services.twitter.requests
{
	import com.adobe.services.twitter.TwitterRequest;
	import com.adobe.services.twitter.Twitter;
	import com.adobe.services.twitter.TwitterUser;
	
	public class TwitterFriendsRequest extends TwitterRequest
	{
		
		public var friendsResponse:Array; //an array of TwitterFriend objects
		
		public function TwitterFriendsRequest( twitter:Twitter )
		{
			super( twitter, "friends" );
		}
		
		override protected function parseResponse(data:XML):*
		{
			friendsResponse = new Array();
			twitter.friends.removeAll();
						
			for each( var user:XML in data.user )
			{
				var tu:TwitterUser = new TwitterUser();
					tu.parseData( user );
					
				friendsResponse.push( tu );
				twitter.friends.addItem( tu );
			}
			
			return friendsResponse;
		}
		
	}
}