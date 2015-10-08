This package contains 2 directories:
1. "desktop_air" - files necessary for your AIR application.
2. "desktop_flash" - desktop flash applications sources.

# Compiling and customization of Desktop AIR application
If you want to compile the AIR Desktop application with your custom changes, then you need do the following:
1. Get the latest AIR SDK at http://www.adobe.com/cfusion/entitlement/index.cfm?e=airsdk
2. Unzip the SDK let's say to "C:\" on your PC
3. Place "desktop_air" directory to the root of unzipped SDK (the whole directory, not just contents)
4. Edit "url.js" file, setting your site url instead of "[your_site]" text there. Save the file
5. You can also replace default Boonex icons with your own ones, just replace "icon16.png", "icon32.png", "icon48.png", "icon128.png" files with your own ones with the same names. Make sure that images are in png format and have dimensions 16x16. 32x32, 48x48 and 128x128 respectively
6. You can change the application title from default "Desktop" to your custom one by editing the "application.xml" file. Replace "Desktop" text with the necessary one
7. After all changes are made, now you compile the application. You should change the current directory in command line to the "C:\[AIR_SDK]\desktop_air". Make sure to replace [AIR_SDK] with the correct path
8. Use the following command to compile the application for Windows OS:
    ..\bin\adt -package -storetype pkcs12 -keystore testCert.pfx -storepass 12345 -target native desktop.exe application.xml index.html desktop_main.swf users.html desktop.swf notification.html notification.swf AC_RunActiveContent.js AIRAliases.js icon16.png icon32.png icon48.png icon128.png url.js
9. Use the following command to compile the application for Mac OS:
    ..\bin\adt -package -storetype pkcs12 -keystore testCert.pfx -storepass 12345 -target native desktop.dmg application.xml index.html desktop_main.swf users.html desktop.swf notification.html notification.swf AC_RunActiveContent.js AIRAliases.js icon16.png icon32.png icon48.png icon128.png url.js
10. That will give you "desktop.exe" and "desktop.dmg" files. Publish them on your site

# Customization of flash applications
1. If you need to customize flash applications then you can edit "desktop_flash\desktop\.fla" files. The recommended editor is Adobe Flash CS3. Place published files into "desktop_air" directory and compile the AIR application. Read above instructions to learn how to do that
2. It is strongly recommended not to edit these files if you have no good flash experience.
3. The easiest way to change the look of your flash applications is to edit "desktop_flash\desktop\skins\default.fla" file, that is responsible for all colors (including fonts) and shapes in the users list desktop application.
4. After making some changes in that file, you should publish it and place the result "default.swf" file into "flash/modules/desktop/skins/" directory on your site replacing the original file.

# Expired certificate problem
If the certificate is expired, use the following command to generate new one:
    ..\bin\adt -certificate -cn BoonEx 2048-RSA testCert2.pfx 12345
