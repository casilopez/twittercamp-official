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
	[Bindable]
	public class TwitterUser
	{
		public var id:String;
		public var name:String;
		public var screenName:String;
		public var location:String;
		public var description:String;
		public var profileImageUrl:String;
		public var url:String;
		public var status:TwitterStatus;		
		
		public function parseData( data:XML ):void
		{
			id = data.id;
			name = data.name;
			screenName = data.screen_name;
			location = data.location;
			description = data.description;
			profileImageUrl = data.profile_image_url;
			
			if( data.status.length > 0 )
			{
				status = new TwitterStatus();
				status.parseData( data.status );
			}
		}
	}
}