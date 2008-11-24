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
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
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
	   public static const DEFAULT_FOOTER_MESSAGE:String = "To see your message on this screen, create an account at Twitter.com, and add @onairbustour to your message.";	   
	   public static const DEFAULT_SEARCH_TERMS:String = "@onairbustour OR from:onairbustour";
	   
	   public var searchTerms:String = DEFAULT_SEARCH_TERMS;
	   public var backgroundLogoUrl:String = DEFAULT_BACKGROUND_LOGO;
	   public var backgroundColor:Number = DEFAULT_BACKGROUND_COLOR;
	   public var backgroundImageUrl:String = DEFAULT_BACKGROUND_IMAGE;
	   public var footerLogoUrl:String = DEFAULT_FOOTER_LOGO;
	   public var bubbleLogoUrl:String = DEFAULT_BUBBLE_LOGO;
	   public var footerMessage:String = DEFAULT_FOOTER_MESSAGE;
	   public var footerHeight:Number = DEFAULT_FOOTER_HEIGHT;
	   public var useCustomSkin:Boolean = false;
	   
	   public var customSkin:Object = {
	   			backgroundLogoUrl : DEFAULT_BACKGROUND_LOGO,
				backgroundColor : DEFAULT_BACKGROUND_COLOR,
				backgroundImageUrl : DEFAULT_BACKGROUND_IMAGE,
				footerLogoUrl : DEFAULT_FOOTER_LOGO,
				bubbleLogoUrl : DEFAULT_BUBBLE_LOGO,
				footerHeight : DEFAULT_FOOTER_HEIGHT,
				footerMessage : DEFAULT_FOOTER_MESSAGE		
	   }
	   
	   public function TwitterCampModel()
	   {
			retrieveModel();	   	
	   }
		
		public function setDefaultSkin():void
		{
			backgroundLogoUrl = DEFAULT_BACKGROUND_LOGO;
			backgroundColor = DEFAULT_BACKGROUND_COLOR;
			backgroundImageUrl = DEFAULT_BACKGROUND_IMAGE;
			footerLogoUrl = DEFAULT_FOOTER_LOGO;
			bubbleLogoUrl = DEFAULT_BUBBLE_LOGO;
			footerHeight = DEFAULT_FOOTER_HEIGHT;
			footerMessage = DEFAULT_FOOTER_MESSAGE;	
		}
		
		public function setCustomSkin():void
		{
			backgroundLogoUrl = customSkin.backgroundLogoUrl;
			backgroundColor = customSkin.backgroundColor;
			backgroundImageUrl = customSkin.backgroundImageUrl;
			footerLogoUrl = customSkin.footerLogoUrl;
			bubbleLogoUrl = customSkin.bubbleLogoUrl;
			footerHeight = customSkin.footerHeight;
			footerMessage = customSkin.footerMessage;				
		}
		
		public function flushModel():void
		{
			if( useCustomSkin )
			{
				customSkin.backgroundLogoUrl = backgroundLogoUrl;
				customSkin.backgroundColor = backgroundColor;
				customSkin.backgroundImageUrl = backgroundImageUrl;
				customSkin.footerLogoUrl = footerLogoUrl;
				customSkin.bubbleLogoUrl = bubbleLogoUrl;
				customSkin.footerMessage = footerMessage;
				customSkin.footerHeight = footerHeight;				
			}
			var customSkinBytes:ByteArray = new ByteArray();
			customSkinBytes.writeObject( customSkin );
			EncryptedLocalStore.setItem("com.danieldura.twittercamp.config.customSkin",customSkinBytes);
			
			var searchTermBytes:ByteArray = new ByteArray();
			searchTermBytes.writeUTF( searchTerms );
			EncryptedLocalStore.setItem("com.danieldura.twittercamp.config.searchTerms", searchTermBytes );

			var useCustomBytes:ByteArray = new ByteArray();
			useCustomBytes.writeBoolean( useCustomSkin );
			EncryptedLocalStore.setItem("com.danieldura.twittercamp.config.useCustomSkin", useCustomBytes );	
		}
		
		public function retrieveModel():void
		{
			var useCustomBytes:ByteArray = EncryptedLocalStore.getItem("com.danieldura.twittercamp.config.useCustomSkin");
			if( useCustomBytes )
				useCustomSkin = useCustomBytes.readBoolean();

			var searchTermBytes:ByteArray = EncryptedLocalStore.getItem("com.danieldura.twittercamp.config.searchTerms");
			if( searchTermBytes )
				searchTerms = searchTermBytes.readUTF();
			
			var configBytes:ByteArray = EncryptedLocalStore.getItem("com.danieldura.twittercamp.config.customSkin");
			if( configBytes )
			{
				var config:Object = configBytes.readObject();
				customSkin.backgroundLogoUrl = config.backgroundLogoUrl;
				customSkin.backgroundColor = config.backgroundColor;
				customSkin.backgroundImageUrl = config.backgroundImageUrl;
				customSkin.footerLogoUrl = config.footerLogoUrl;
				customSkin.bubbleLogoUrl = config.bubbleLogoUrl;
				customSkin.footerMessage = config.footerMessage;
				customSkin.footerHeight = config.footerHeight;
			}
		}
		
		public function resetModel():void
		{
				EncryptedLocalStore.removeItem("com.danieldura.twittercamp.config.useCustomSkin");
				EncryptedLocalStore.removeItem("com.danieldura.twittercamp.config.searchTerms");
				EncryptedLocalStore.removeItem("com.danieldura.twittercamp.config.customSkin");			
		}
	}
}