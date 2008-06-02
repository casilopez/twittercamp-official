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

package com.adobe.twittercamp.models
{
	import com.adobe.services.twitter.Twitter;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[Bindable]
	public class TwitterCampModel
	{
		private static var twitterCampModel:TwitterCampModel;
		
		public static function getInstance() : TwitterCampModel
		{
			if ( twitterCampModel == null )
				twitterCampModel = new TwitterCampModel();
				
			return twitterCampModel;
		}

//--------------------------------------------------------------------------------------
	   
	   public static const DEFAULT_BACKGROUND_LOGO:String = "skins/background_logo.png";
	   public static const DEFAULT_BACKGROUND_COLOR:Number = 0xFFFFFF;
	   public static const DEFAULT_BACKGROUND_IMAGE:String = "skins/background.png";
	   public static const DEFAULT_BUBBLE_LOGO:String = "skins/bubble_logo.png";
	   public static const DEFAULT_FOOTER_LOGO:String = "skins/banner_logo.png";
	   public static const DEFAULT_FOOTER_HEIGHT:Number = 168;
	   
	   public var twitter:Twitter = new Twitter();
	   public var timelineUsername:String;
	   public var config:XML;
	   
	   public var backgroundLogoUrl:String = DEFAULT_BACKGROUND_LOGO;
	   public var backgroundColor:Number = DEFAULT_BACKGROUND_COLOR;
	   public var backgroundImageUrl:String = DEFAULT_BACKGROUND_IMAGE;
	   public var footerLogoUrl:String = DEFAULT_FOOTER_LOGO;
	   public var bubbleLogoUrl:String = DEFAULT_BUBBLE_LOGO;
	   public var footerMessage:String;
	   public var footerHeight:Number = DEFAULT_FOOTER_HEIGHT;
	   
	   public function TwitterCampModel()
	   {
	   		loadConfig();
	   }
		
		
		public function resetSkins():void
		{
			backgroundLogoUrl = DEFAULT_BACKGROUND_LOGO;
			backgroundColor = DEFAULT_BACKGROUND_COLOR;
			backgroundImageUrl = DEFAULT_BACKGROUND_IMAGE;
			footerLogoUrl = DEFAULT_FOOTER_LOGO;
			bubbleLogoUrl = DEFAULT_BUBBLE_LOGO;
			footerHeight = DEFAULT_FOOTER_HEIGHT;
			footerMessage = config.message;			
		}
		
		public function loadConfig():void
		{
			var loader:URLLoader = new URLLoader();
				loader.addEventListener( Event.COMPLETE, handle_loadComplete );
				loader.load( new URLRequest( "config.xml" ) );
		}	   
		
		private function handle_loadComplete( event:Event ):void
		{
			config = new XML( URLLoader( event.target ).data );
			footerMessage = config.message;
		}
	}
}