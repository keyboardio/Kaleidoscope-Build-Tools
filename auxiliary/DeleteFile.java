/* Kaleidoscope - Firmware for computer input devices
 * Copyright (C) 2013-2018  Keyboard.io, Inc.
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 */
 
// This untility is necesary to delete files during the build process
// Arduino does not support this feature directly.

import java.io.File;

public class DeleteFile
{
    public static void main(String[] args)
    {	
      if(args.length != 1) {
         System.out.println("usage: java DeleteFile <filepath>");
         System.exit(0);
      }
         
    	try{
    		
    		File file = new File(args[0]);
    		
     		if(file.delete()){
     			System.out.println("Deleted \'" + file.getName() + "\'");
     		}else{
     			System.out.println("Unable to delete \'" + args[0] + "\'");
     		}
    	   
    	}catch(Exception e){
    		
    		e.printStackTrace();
    		
    	}
    	
    }
}
