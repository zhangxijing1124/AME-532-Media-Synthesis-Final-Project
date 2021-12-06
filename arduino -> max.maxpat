{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 8,
			"minor" : 1,
			"revision" : 0,
			"architecture" : "x64",
			"modernui" : 1
		}
,
		"classnamespace" : "box",
		"rect" : [ 92.0, 87.0, 967.0, 852.0 ],
		"bglocked" : 0,
		"openinpresentation" : 0,
		"default_fontsize" : 12.0,
		"default_fontface" : 0,
		"default_fontname" : "Arial",
		"gridonopen" : 1,
		"gridsize" : [ 15.0, 15.0 ],
		"gridsnaponopen" : 1,
		"objectsnaponopen" : 1,
		"statusbarvisible" : 2,
		"toolbarvisible" : 1,
		"lefttoolbarpinned" : 0,
		"toptoolbarpinned" : 0,
		"righttoolbarpinned" : 0,
		"bottomtoolbarpinned" : 0,
		"toolbars_unpinned_last_save" : 0,
		"tallnewobj" : 0,
		"boxanimatetime" : 200,
		"enablehscroll" : 1,
		"enablevscroll" : 1,
		"devicewidth" : 0.0,
		"description" : "",
		"digest" : "",
		"tags" : "",
		"style" : "",
		"subpatcher_template" : "",
		"boxes" : [ 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-26",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 370.0, 119.0, 80.0, 20.0 ],
					"text" : "arduino code"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-27",
					"linecount" : 260,
					"maxclass" : "textedit",
					"numinlets" : 1,
					"numoutlets" : 4,
					"outlettype" : [ "", "int", "", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 370.0, 149.0, 261.0, 293.0 ],
					"presentation_linecount" : 260,
					"text" : "#include <Wire.h>\n#include <SPI.h>\n#include <SparkFunLSM9DS1.h>\n\n//////////////////////////\n// LSM9DS1 Library Init //\n//////////////////////////\n// Use the LSM9DS1 class to create an object. [imu] can be\n// named anything, we'll refer to that throught the sketch.\nLSM9DS1 imu;\n\n///////////////////////\n// Example I2C Setup //\n///////////////////////\n// SDO_XM and SDO_G are both pulled high, so our addresses are:\n// #define LSM9DS1_M\t0x1E // Would be 0x1C if SDO_M is LOW\n// #define LSM9DS1_AG\t0x6B // Would be 0x6A if SDO_AG is LOW\n\n////////////////////////////\n// Sketch Output Settings //\n////////////////////////////\n#define PRINT_CALCULATED\n//#define PRINT_RAW\n#define PRINT_SPEED 250 // 250 ms between prints\nstatic unsigned long lastPrint = 0; // Keep track of print time\n\n// Earth's magnetic field varies by location. Add or subtract\n// a declination to get a more accurate heading. Calculate\n// your's here:\n// http://www.ngdc.noaa.gov/geomag-web/#declination\n#define DECLINATION -8.58 // Declination (degrees) in Boulder, CO.\n\n//Function definitions\nvoid printGyro();\nvoid printAccel();\nvoid printMag();\nvoid printAttitude(float ax, float ay, float az, float mx, float my, float mz);\n\nvoid setup()\n{\n  Serial.begin(115200);\n\n  Wire.begin();\n\n  if (imu.begin() == false) // with no arguments, this uses default addresses (AG:0x6B, M:0x1E) and i2c port (Wire).\n  {\n    Serial.println(\"Failed to communicate with LSM9DS1.\");\n    Serial.println(\"Double-check wiring.\");\n    Serial.println(\"Default settings in this sketch will \" \\\n                   \"work for an out of the box LSM9DS1 \" \\\n                   \"Breakout, but may need to be modified \" \\\n                   \"if the board jumpers are.\");\n    while (1);\n  }\n}\n\nvoid loop()\n{\n  // Update the sensor values whenever new data is available\n  if ( imu.gyroAvailable() )\n  {\n    // To read from the gyroscope,  first call the\n    // readGyro() function. When it exits, it'll update the\n    // gx, gy, and gz variables with the most current data.\n    imu.readGyro();\n  }\n  if ( imu.accelAvailable() )\n  {\n    // To read from the accelerometer, first call the\n    // readAccel() function. When it exits, it'll update the\n    // ax, ay, and az variables with the most current data.\n    imu.readAccel();\n  }\n  if ( imu.magAvailable() )\n  {\n    // To read from the magnetometer, first call the\n    // readMag() function. When it exits, it'll update the\n    // mx, my, and mz variables with the most current data.\n    imu.readMag();\n  }\n\n  if ((lastPrint + PRINT_SPEED) < millis())\n  {\n    printGyro();  // Print \"G: gx, gy, gz\"\n    printAccel(); // Print \"A: ax, ay, az\"\n    printMag();   // Print \"M: mx, my, mz\"\n    // Print the heading and orientation for fun!\n    // Call print attitude. The LSM9DS1's mag x and y\n    // axes are opposite to the accelerometer, so my, mx are\n    // substituted for each other.\n    printAttitude(imu.ax, imu.ay, imu.az,\n                  -imu.my, -imu.mx, imu.mz);\n    Serial.println();\n\n    lastPrint = millis(); // Update lastPrint time\n  }\n}\n\nvoid printGyro()\n{\n  // Now we can use the gx, gy, and gz variables as we please.\n  // Either print them as raw ADC values, or calculated in DPS.\n//  Serial.print(\"G: \");\n#ifdef PRINT_CALCULATED\n  // If you want to print calculated values, you can use the\n  // calcGyro helper function to convert a raw ADC value to\n  // DPS. Give the function the value that you want to convert.\n//  Serial.print(imu.calcGyro(imu.gx), 2);\n//  Serial.print(\", \");\n//  Serial.print(imu.calcGyro(imu.gy), 2);\n//  Serial.print(\", \");\n//  Serial.print(imu.calcGyro(imu.gz), 2);\n//  Serial.println(\" deg/s\");\n#elif defined PRINT_RAW\n//  Serial.print(imu.gx);\n//  Serial.print(\", \");\n//  Serial.print(imu.gy);\n//  Serial.print(\", \");\n//  Serial.println(imu.gz);\n#endif\n}\n\nvoid printAccel()\n{\n  // Now we can use the ax, ay, and az variables as we please.\n  // Either print them as raw ADC values, or calculated in g's.\n//  Serial.print(\"A: \");\n#ifdef PRINT_CALCULATED\n  // If you want to print calculated values, you can use the\n  // calcAccel helper function to convert a raw ADC value to\n  // g's. Give the function the value that you want to convert.\n//  Serial.print(imu.calcAccel(imu.ax), 2);\n//  Serial.print(\", \");\n//  Serial.print(imu.calcAccel(imu.ay), 2);\n//  Serial.print(\", \");\n//  Serial.print(imu.calcAccel(imu.az), 2);\n//  Serial.println(\" g\");\n#elif defined PRINT_RAW\n//  Serial.print(imu.ax);\n//  Serial.print(\", \");\n//  Serial.print(imu.ay);\n//  Serial.print(\", \");\n//  Serial.println(imu.az);\n#endif\n\n}\n\nvoid printMag()\n{\n  // Now we can use the mx, my, and mz variables as we please.\n  // Either print them as raw ADC values, or calculated in Gauss.\n//  Serial.print(\"M: \");\n#ifdef PRINT_CALCULATED\n  // If you want to print calculated values, you can use the\n  // calcMag helper function to convert a raw ADC value to\n  // Gauss. Give the function the value that you want to convert.\n//  Serial.print(imu.calcMag(imu.mx), 2);\n//  Serial.print(\", \");\n//  Serial.print(imu.calcMag(imu.my), 2);\n//  Serial.print(\", \");\n//  Serial.print(imu.calcMag(imu.mz), 2);\n//  Serial.println(\" gauss\");\n#elif defined PRINT_RAW\n//  Serial.print(imu.mx);\n//  Serial.print(\", \");\n//  Serial.print(imu.my);\n//  Serial.print(\", \");\n//  Serial.println(imu.mz);\n#endif\n}\n\n// Calculate pitch, roll, and heading.\n// Pitch/roll calculations take from this app note:\n// https://web.archive.org/web/20190824101042/http://cache.freescale.com/files/sensors/doc/app_note/AN3461.pdf\n// Heading calculations taken from this app note:\n// https://web.archive.org/web/20150513214706/http://www51.honeywell.com/aero/common/documents/myaerospacecatalog-documents/Defense_Brochures-documents/Magnetic__Literature_Application_notes-documents/AN203_Compass_Heading_Using_Magnetometers.pdf\nvoid printAttitude(float ax, float ay, float az, float mx, float my, float mz)\n{\n  float roll = atan2(ay, az);\n  float pitch = atan2(-ax, sqrt(ay * ay + az * az));\n\n  float heading;\n  if (my == 0)\n    heading = (mx < 0) ? PI : 0;\n  else\n    heading = atan2(mx, my);\n\n  heading -= DECLINATION * PI / 180;\n\n  if (heading > PI) heading -= (2 * PI);\n  else if (heading < -PI) heading += (2 * PI);\n\n  // Convert everything from radians to degrees:\n  heading *= 180.0 / PI;\n  pitch *= 180.0 / PI;\n  roll  *= 180.0 / PI;\n\n  Serial.print(\"Pitch, Roll: \");\n  Serial.print(pitch, 2);\n  Serial.print(\", \");\n  Serial.println(roll, 2);\n  Serial.print(\"Heading: \"); \n  Serial.println(heading, 2);\n}"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-15",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 63.0, 33.0, 72.0, 20.0 ],
					"text" : "serial on/off"
				}

			}
, 			{
				"box" : 				{
					"color" : [ 0.317647, 0.709804, 0.321569, 1.0 ],
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-70",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 73.0, 100.5, 89.0, 22.0 ],
					"text" : "loadmess print"
				}

			}
, 			{
				"box" : 				{
					"allowdrag" : 0,
					"bgcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"bgfillcolor_color" : [ 1.0, 1.0, 1.0, 1.0 ],
					"bgfillcolor_color1" : [ 0.301961, 0.301961, 0.301961, 1 ],
					"bgfillcolor_color2" : [ 0.2, 0.2, 0.2, 1 ],
					"bgfillcolor_type" : "color",
					"fontname" : "Verdana",
					"fontsize" : 12.0,
					"id" : "obj-71",
					"items" : [ "BLTH", ",", "Bluetooth-Incoming-Port" ],
					"labelclick" : 1,
					"maxclass" : "umenu",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "int", "", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 105.0, 73.0, 161.0, 23.0 ],
					"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Verdana",
					"fontsize" : 12.0,
					"id" : "obj-72",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 176.0, 98.5, 89.0, 23.0 ],
					"text" : "prepend port"
				}

			}
, 			{
				"box" : 				{
					"color" : [ 0.321569, 0.184314, 0.454902, 1.0 ],
					"fontname" : "Verdana",
					"fontsize" : 12.0,
					"id" : "obj-16",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 8,
							"minor" : 1,
							"revision" : 0,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 522.0, 114.0, 192.0, 180.0 ],
						"bglocked" : 0,
						"openinpresentation" : 0,
						"default_fontsize" : 12.0,
						"default_fontface" : 0,
						"default_fontname" : "Verdana",
						"gridonopen" : 1,
						"gridsize" : [ 15.0, 15.0 ],
						"gridsnaponopen" : 1,
						"objectsnaponopen" : 1,
						"statusbarvisible" : 2,
						"toolbarvisible" : 1,
						"lefttoolbarpinned" : 0,
						"toptoolbarpinned" : 0,
						"righttoolbarpinned" : 0,
						"bottomtoolbarpinned" : 0,
						"toolbars_unpinned_last_save" : 0,
						"tallnewobj" : 0,
						"boxanimatetime" : 200,
						"enablehscroll" : 1,
						"enablevscroll" : 1,
						"devicewidth" : 0.0,
						"description" : "",
						"digest" : "",
						"tags" : "",
						"style" : "",
						"subpatcher_template" : "",
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-1",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 129.0, 79.0, 20.0, 20.0 ]
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 12.0,
									"id" : "obj-2",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 129.0, 106.0, 40.0, 19.0 ],
									"text" : "clear"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 12.0,
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 15.0, 106.0, 109.0, 21.0 ],
									"text" : "prepend append"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 12.0,
									"id" : "obj-4",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 15.0, 79.0, 56.0, 21.0 ],
									"text" : "zl iter 1"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 12.0,
									"id" : "obj-5",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 15.0, 42.0, 71.0, 21.0 ],
									"text" : "route port"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-6",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 15.0, 145.0, 25.0, 25.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-7",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 15.0, 8.0, 25.0, 25.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"midpoints" : [ 138.5, 134.5, 24.5, 134.5 ],
									"source" : [ "obj-2", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-3", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"midpoints" : [ 24.5, 70.5, 138.5, 70.5 ],
									"order" : 0,
									"source" : [ "obj-5", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 0 ],
									"order" : 1,
									"source" : [ "obj-5", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-5", 0 ],
									"source" : [ "obj-7", 0 ]
								}

							}
 ]
					}
,
					"patching_rect" : [ 101.0, 160.0, 92.0, 23.0 ],
					"saved_object_attributes" : 					{
						"description" : "",
						"digest" : "",
						"fontname" : "Verdana",
						"globalpatchername" : "",
						"tags" : ""
					}
,
					"text" : "p createMenu"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-22",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 125.0, 232.0, 166.0, 33.0 ],
					"text" : "< after each linebreak, groups variables into a string "
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-21",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 125.0, 199.0, 128.0, 20.0 ],
					"text" : "< looks for a linebreak"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"format" : 6,
					"id" : "obj-2",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 41.0, 436.0, 65.0, 22.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"format" : 6,
					"id" : "obj-18",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 40.0, 408.0, 65.0, 22.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"format" : 6,
					"id" : "obj-11",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 39.0, 380.0, 65.0, 22.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"format" : 6,
					"id" : "obj-3",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 40.0, 351.0, 65.0, 22.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-28",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 24.0, 436.0, 19.0, 20.0 ],
					"text" : "z:"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-4",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 24.0, 408.0, 19.0, 20.0 ],
					"text" : "y:"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-23",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 24.0, 380.0, 19.0, 20.0 ],
					"text" : "x:"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-6",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 8.0, 351.0, 37.0, 20.0 ],
					"text" : "time:"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-7",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 4,
					"outlettype" : [ "float", "float", "float", "float" ],
					"patching_rect" : [ 40.0, 325.0, 199.0, 22.0 ],
					"text" : "unpack 0. 0. 0. 0."
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-17",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 40.0, 299.0, 73.0, 22.0 ],
					"text" : "fromsymbol"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-14",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "bang", "" ],
					"patching_rect" : [ 40.0, 196.0, 47.0, 22.0 ],
					"text" : "sel 10"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-10",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 125.0, 274.0, 211.0, 20.0 ],
					"text" : "< converts ASCII values to characters"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-8",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"patching_rect" : [ 40.0, 273.0, 34.0, 22.0 ],
					"text" : "itoa"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-9",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 40.0, 231.0, 83.0, 22.0 ],
					"text" : "zl group 1000"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-19",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 40.0, 33.0, 20.0, 20.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-20",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 40.0, 73.0, 58.0, 22.0 ],
					"text" : "metro 2"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-24",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "int", "" ],
					"patching_rect" : [ 40.0, 136.0, 80.0, 22.0 ],
					"text" : "serial a 9600"
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-9", 0 ],
					"midpoints" : [ 77.5, 221.5, 49.5, 221.5 ],
					"source" : [ "obj-14", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-9", 0 ],
					"source" : [ "obj-14", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-71", 0 ],
					"midpoints" : [ 110.5, 187.0, 285.5, 187.0, 285.5, 63.5, 114.5, 63.5 ],
					"source" : [ "obj-16", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-7", 0 ],
					"source" : [ "obj-17", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-20", 0 ],
					"source" : [ "obj-19", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-24", 0 ],
					"source" : [ "obj-20", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-14", 0 ],
					"source" : [ "obj-24", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-16", 0 ],
					"source" : [ "obj-24", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-11", 0 ],
					"midpoints" : [ 109.5, 376.0, 48.5, 376.0 ],
					"source" : [ "obj-7", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-18", 0 ],
					"midpoints" : [ 169.5, 403.5, 49.5, 403.5 ],
					"source" : [ "obj-7", 2 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-2", 0 ],
					"midpoints" : [ 229.5, 432.0, 50.5, 432.0 ],
					"source" : [ "obj-7", 3 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-3", 0 ],
					"source" : [ "obj-7", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-24", 0 ],
					"midpoints" : [ 82.5, 128.75, 49.5, 128.75 ],
					"source" : [ "obj-70", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-72", 0 ],
					"source" : [ "obj-71", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-24", 0 ],
					"midpoints" : [ 185.5, 128.25, 49.5, 128.25 ],
					"source" : [ "obj-72", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-17", 0 ],
					"source" : [ "obj-8", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-8", 0 ],
					"source" : [ "obj-9", 0 ]
				}

			}
 ],
		"dependency_cache" : [  ],
		"autosave" : 0
	}

}
