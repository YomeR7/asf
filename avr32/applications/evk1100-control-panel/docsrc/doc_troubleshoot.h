/*****************************************************************************
 *
 * \file
 *
 * \brief EVK1100 Control Panel Trouble Shooting guide.
 *
 * The Control Panel application is a demonstration application. Its purpose is
 * to automatically log local sensors and actuators data and events and make
 * these available through the various connectivity channels supported by the
 * AVR32.\n
 * The logs are accessible locally through USART or USB (Mass Storage class),
 * and/or remotely through the Internet (Web server).\n
 * The Control Panel is locally configurable through USART or USB (Mass Storage
 * class) or remotely configurable through the Internet (Web server).
 *
 * - OS:                 FreeRTOS port on AVR UC3.
 * - Boards:             EVK1100
 *
 * Copyright (c) 2014-2018 Microchip Technology Inc. and its subsidiaries.
 *
 * \asf_license_start
 *
 * \page License
 *
 * Subject to your compliance with these terms, you may use Microchip
 * software and any derivatives exclusively with Microchip products.
 * It is your responsibility to comply with third party license terms applicable
 * to your use of third party software (including open source software) that
 * may accompany Microchip software.
 *
 * THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES,
 * WHETHER EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE,
 * INCLUDING ANY IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY,
 * AND FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT WILL MICROCHIP BE
 * LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE, INCIDENTAL OR CONSEQUENTIAL
 * LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND WHATSOEVER RELATED TO THE
 * SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS BEEN ADVISED OF THE
 * POSSIBILITY OR THE DAMAGES ARE FORESEEABLE.  TO THE FULLEST EXTENT
 * ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN ANY WAY
 * RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
 * THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
 *
 * \asf_license_stop
 *
 *****************************************************************************/

/*! \page TroubleShootingGuide Trouble Shooting Guide
 *
 * <HR>
 * \section CpUsbDeviceMassStorageNoConnect I connected the Control Panel to my PC through USB, but the PC doesn't see the Control Panel.
 * You must tell the Control Panel to behave as a USB key by pressing the
 * joystick once (cf. the default message on the LCD menu line <b><i>"   Set as USB key   "</i></b>).
 * \n Also, to leave this Mass Storage device mode, you must tell the Control Panel to do so
 * by pressing the joystick once.
 * \note For a step-by-step description, take a look at the \ref UsbCpMassStorageDevice scenario.
 *
 * <HR>
 * \section CpUsbDeviceMassStorageFat I connected the Control Panel to my PC through USB, and the PC tells me that the Control Panel memory is not formatted.
 * Format the memory with the File System set to FAT.
 * \warning Note that once the Control Panel's memory has been formatted, the
 * /WEB directory need to be restored in order to use the Control Panel's Web
 * server: for an example on how to do that, check the \ref RestoringWebServerFiles
 * scenario. \n Also, if you want the logs to be saved in files, you have to
 * create the /LOG directory: see the \ref ShellCreatingLogDir example.
 *
 * <HR>
 * \section CpUsbDeviceMassStorageCopy I updated the WEB server files of the Control Panel from my PC through USB. After USB disconnection, i connect to the Web server but i can clearly see that the WEB server files are not the new ones but the old version.
 * Before unplugging the Control Panel from the PC, it is best to safely unplug the USB device through the Windows task tray(as you would with any USB device plugged on a PC):\n
 * \n
 * \image html UsbMsDevUnplug.gif
 * \n
 *
 * <HR>
 * \section CpUsbDeviceMsNoWsNoShlCmds While the Control Panel is plugged to my PC through USB behaving as a USB key, the Web server is not reachable, and the file system commands on the shell interface are unavailable.
 * Indeed, your web browser will display the following information:\n
 * \n
 * \image html UsbWebMaintenance.gif
 * \n
 * and each file system command will reply with the following error message:\n
 * \n
 * \image html ShellUnavailableCmd.gif
 * \n
 * This is normal because in this mode the Control Panel's memory "belongs" to
 * the PC: the Control Panel is seen as a USB key from the PC's point of view;
 * which means that the PC can at any time perform any action on the memory
 * (including, for example, removing the /WEB directory).
 * Thus, any read/write action from/to the Control Panel's file system memory
 * outside the scope of the PC cannot be guaranteed. This is why the Web server
 * cannot serve the "regular" files (it is still reachable, this is how the web
 * browser gets the "Web server under maintenance" page) and the file system
 * commands are unavailable.
 *
 *
 * <HR>
 * \section contactinfo Contact Information
 * For further information, visit
 * <A href="http://www.microchip.com/design-centers/32-bit">Atmel AVR</A>.\n
 */
/*
 * Support and FAQ: visit <a href="https://www.microchip.com/support/">Microchip Support</a>
 */
