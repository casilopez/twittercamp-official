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

package com.adobe.services.twitter.utils
{
	public class DateUtils
	{
		
		public static function relativize( d:Date, relativeTo:Date = null ):String
		{
			relativeTo ||= new Date();
			var delta:Number = Math.floor( ( relativeTo.time - d.time ) / 1000 );
			
			if( delta < 0 )
			{
				return 'in the future';
			}
			if( delta < 60 )
			{
				return 'less than a minute ago';
			}
			else if( delta < 120 )
			{
				return 'about a minute ago';
			}
			else if( delta < ( 45 * 60 ) )
			{
				return Math.floor(delta / 60) + ' minutes ago';
			}
			else if( delta < ( 90 * 60 ) )
			{
				return 'about an hour ago';
			}
			else if( delta < ( 24 * 60 * 60 ) )
			{
				return 'about ' + Math.floor(delta / 3600) + ' hours ago';
			}
			else if(delta < (48*60*60) )
			{
				return '1 day ago';
			}
			else if( delta >= (48*60*60) )
			{
				return Math.floor(delta / 86400) + ' days ago';
			}
			return null;
		}
				
	}
}