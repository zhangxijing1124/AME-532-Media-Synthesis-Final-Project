# AME-532-Media-Synthesis-Final-Project
Contains files and process for AME 532 Media Synthesis Final Project

**Materials Needed:**
1. Arduino Uno Rev3
2. LSM9DS1(IMU)
![image](https://user-images.githubusercontent.com/90342967/144937512-354bc7a4-fd9e-4a82-ae3a-9511319471a1.png)
![image](https://user-images.githubusercontent.com/90342967/144937488-b33b0c44-2a60-48bd-8f9e-dd577ae8638e.png)


**Step1:**
Installing Arduino Library SparkFun_LSM9DS1_Arduino_Library-master, the file have more deteil of process.

**Step2:**
Connect the IMU to the Arduino uno. 
1. VCC → 3.3V
2. GND → GND
3. SDA → SDA/A4
4. SCL → SCL/A5

**Step3:**
Compile and upload the IMU.ino files in the folder IMU to Arduino Uno Rev3.
![image](https://user-images.githubusercontent.com/90342967/144937636-fbe87f85-c468-4f3d-952d-79e64cbae538.png)

**Step4:**
Open the Final Project.maxproj file in the Final Project folder. And set this data to 350000.
![image](https://user-images.githubusercontent.com/90342967/144937191-55c071e1-737a-4684-bb88-9886ea37651c.png)
![image](https://user-images.githubusercontent.com/90342967/144937213-c36a7968-4850-46e3-a66b-376dffb6d4f1.png)

**Step5:**
The "heading" output of the IMU can be used to control the concentration of particles now. In order to facilitate the test, the parameter adjustment can still be completed without the IMU sensor. But adding IMU sensor will have better effect.
<img width="784" alt="Screen Shot 2021-12-06 at 4 19 35 PM" src="https://user-images.githubusercontent.com/90342967/144938302-2fa7cc37-5bae-4f06-a16c-071b103e8b04.png">
![image](https://user-images.githubusercontent.com/90342967/144938486-95771d2f-f9d6-4c0f-bcec-782bc32b8234.png)
