import os
 
filepath = "./wave_data/" #添加路径
filename= os.listdir(filepath) #得到文件夹下的所有文件名称

print(filename)

'''
wave.open(filename,mode)

mode ： 'rb' 读取文件
		'wb' 写入文件

不支持同时读写

'''

import wave
import numpy as np
import matplotlib.pyplot as plt
for i in range(0,len(filename)):
	noise_2 = wave.open(filepath+filename[i],'rb')
	params_noise_2 = noise_2.getparams()
	nchannels, sampwidth, framerate, nframes = params_noise_2[:4]
	'''
	nchannels:声道数

	sampwidth:量化位数（byte）

	framerate:采样频率

	nframes:采样点数 

	'''

	#初始化时间点数坐标

	#time = [round(x/framerate , 2)  for x in range(nframes)]
	time_np = np.arange(nframes)

	noise_2_data = noise_2.readframes(nframes) #str
	noise_2_data = np.fromstring(noise_2_data,dtype = np.int16)
	noise_2_data = noise_2_data * 1.0 / (max(abs(noise_2_data)))

	noise_2_data = np.reshape(noise_2_data,[nframes , nchannels])

	#频率坐标fre
	#fre =[ round((x-1/2 * nframes) * framerate / nframes) for x in range(nframes)]

	noise_2_data_fft_1 = np.fft.fft(noise_2_data[:,1])
	#noise_2_data_fft_1 = np.fft.fftshift(noise_2_data_fft_1)
	noise_2_data_fft_1 =np.log10(abs(noise_2_data_fft_1 * 1.0 / (max(abs(noise_2_data_fft_1)))))
	fre = np.fft.fftfreq(time_np.shape[-1],1/framerate)

	#去除负频域
	fre = fre[0:int((len(fre)-1)/2)]

	noise_2_data_fft_1 = noise_2_data_fft_1[0:int(len(noise_2_data_fft_1)/2)-1]

	print(len(fre),fre[0:5])

	plt.figure(i)
	plt.plot(fre , noise_2_data_fft_1 , color = 'black' , linestyle = 'solid')
plt.show()
