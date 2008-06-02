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
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import mx.utils.StringUtil;


	import com.adobe.xml.syndication.rss.RSS20;
	import com.adobe.xml.syndication.rss.Item20;
	import com.adobe.services.twitter.events.TwitterResponseEvent;
	import com.adobe.services.twitter.events.TwitterCommandResposeEvent;
	import flash.events.IOErrorEvent;
	import flash.errors.IOError;
	import flash.events.SecurityErrorEvent;
	
	public class TwitterCommandLoader extends EventDispatcher
	{
		private var userID:String;
		private var BASE_URL:String = "http://twitter.com/statuses/user_timeline/{0}.rss";
		
		public function TwitterCommandLoader(userID:String)
		{
			this.userID = userID;
		}
		
		public function load():void
		{
			var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onDataLoad);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				loader.load(new URLRequest(StringUtil.substitute(BASE_URL, userID)));
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			trace("SecurityErrorEvent : " + e.text);	
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			trace("IOErrorEvent : " + e.text);	
		}
		
		private function onDataLoad(e:Event):void
		{
			var statuses:Array = parseData(new XML(URLLoader(e.target).data));
			
			var event:TwitterCommandResposeEvent = new TwitterCommandResposeEvent(TwitterCommandResposeEvent.COMMAND_RESPONSE);
				event.commands = statuses;
				
				dispatchEvent(event);
		}
		
		private function parseData(x:XML):Array
		{
			var rss:RSS20 = new RSS20();
				rss.parse(x);
				
			var items:Array = rss.items;
			
			var out:Array = new Array();
			//var s:TwitterStatus;
			//var u:TwitterUser = new TwitterUser();
			//	u.name = username;
			var c:TwitterCommand;
			for each(var i:Item20 in items)
			{
				/*
				s = new TwitterStatus();
				s.text = stripName(i.description);
				s.user = u;
				s.id = i.guid.id;
				s.publishDate = i.pubDate;
				*/
				
				c = parseCommand(i.description);
				
				if(c == null)
				{
					continue;
				}
				
				c.publishDate = i.pubDate;
				
				out.push(c);
			}
			
			return out;
		}
		
		private function parseCommand(c:String):TwitterCommand
		{
			var msg:String = stripName(c);
			
			if(msg.indexOf("/") != 0)
			{
				return null;
			}
			
			var command:String = msg.substr(1,msg.indexOf(" ") - 1);
			var args:String = msg.substr(msg.indexOf(" ") + 1);
			
			var out:TwitterCommand = new TwitterCommand();
				out.args = args;
				
			switch(command.toLowerCase())
			{
				case "playing":
				{	
					out.command = TwitterCommandType.PLAYING;
					break;
				}
				case "message":
				{
					out.command = TwitterCommandType.MESSAGE;
					break;
				}
				case "session":
				{
					out.command = TwitterCommandType.SESSION;
					break;
				}								
			}
			
			return out;
		}
		
		private function stripName(s:String):String
		{
			return s.substr((s.indexOf(":") + 2));
		}
/*
    <item>
      <title>Apollo Runtime: Doing some testing for Apollo Camp</title>
      <description>Apollo Runtime: Doing some testing for Apollo Camp</description>
      <pubDate>Thu, 15 Mar 2007 04:05:51 +0000</pubDate>
      <guid>http://twitter.com/apollocamp/statuses/8049001</guid>
      <link>http://twitter.com/apollocamp/statuses/8049001</link>
    </item>
*/		
		
	}
}