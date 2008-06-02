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
	import com.adobe.utils.DateUtil;
	import flash.events.EventDispatcher;
	import com.adobe.services.twitter.utils.DateUtils;
	
	[Bindable]
	public class TwitterStatus extends EventDispatcher
	{
		public var createdAt:Date;
		public var id:String;
		public var text:String;
		public var user:TwitterUser;
		
		public function parseData( data:XML ):void
		{
			id = data.id;
			text = data.text;
			
			if( data.user )
			{
				user = new TwitterUser()
				user.parseData( new XML(data.user) );
			}
			
			createdAt = parseDate( data.created_at );
		}
		
		public function get relativeCreatedAt():String
		{
			return DateUtils.relativize( createdAt );
		}
		
		private function parseDate( dateString:String ):Date
		{
			var date:String = dateString.substr( 0, 10 );
			var year:String = dateString.substr( dateString.length - 4, dateString.length );
			var time:String = dateString.substr( 11, 8 );
			var parsedDate:Date = new Date( date + " " + time + " UTC-0000 " + year );
			
			return parsedDate;
		}
		
	}
}