# *********************************************************
# This program illustrates a few commonly-used programming
# features of your Keysight Infiniium Series oscilloscope.
# *********************************************************

# Import modules.
# ---------------------------------------------------------
import visa
import string
import struct
import sys

# Global variables (booleans: 0 = False, 1 = True).
# ---------------------------------------------------------
debug = 0


# =========================================================
# Initialize:初始化
# =========================================================
def initialize():

 # Clear status.
 do_command("*CLS")

 # Get and display the device's *IDN? string.
 #仪器型号
 idn_string = do_query_string("*IDN?")
 print ("Identification string: '%s'" % idn_string)

 # Load the default setup.
 #默认设置
 do_command("*RST")

# =========================================================
# Send a command and binary values and check for errors:
# 发射一个命令和二进制值并检查errors
# =========================================================
def do_command_ieee_block(command, values):
 if debug:
  print ("Cmb = '%s'" % command)
 Infiniium.write_binary_values("%s " % command, values, datatype='c')
 check_instrument_errors(command)


# =========================================================
# Capture:捕获
# =========================================================
def capture():

 # Set probe attenuation factor.
 # 设置探头衰减
 do_command(":CHANnel1:PROBe 1.0")
 qresult = do_query_string(":CHANnel1:PROBe?")
 print ("Channel 1 probe attenuation factor: %s" % qresult)

 # Use auto-scale to automatically set up oscilloscope.
 # 自动测量模式
 print ("Autoscale.")
 do_command(":AUToscale")

 # Set trigger mode.
 # 设置触发模式
 do_command(":TRIGger:MODE EDGE")
 qresult = do_query_string(":TRIGger:MODE?")
 print ("Trigger mode: %s" % qresult)

 # Set EDGE trigger parameters.
 # 边沿触发参数设置
 do_command(":TRIGger:EDGE:SOURCe CHANnel2")
 qresult = do_query_string(":TRIGger:EDGE:SOURce?")
 print ("Trigger edge source: %s" % qresult)

 do_command(":TRIGger:LEVel CHANnel1,330E-3")
 qresult = do_query_string(":TRIGger:LEVel? CHANnel1")
 print ("Trigger level, channel 1: %s" % qresult)

 do_command(":TRIGger:EDGE:SLOPe POSitive")
 qresult = do_query_string(":TRIGger:EDGE:SLOPe?")
 print ("Trigger edge slope: %s" % qresult)

 # Save oscilloscope setup.
 # 保存设置
 sSetup = do_query_ieee_block(":SYSTem:SETup?")

 f = open("setup.stp", "wb")
 f.write(sSetup)
 f.close()
 print ("Setup bytes saved: %d" % len(sSetup))

 # Change oscilloscope settings with individual commands:
 # 修改示波器设置 
 # Set vertical scale and offset.
 # 设置垂直刻度和偏移
 do_command(":CHANnel1:SCALe 0.2")
 qresult = do_query_number(":CHANnel1:SCALe?")
 print ("Channel 1 vertical scale: %f" % qresult)

 do_command(":CHANnel1:OFFSet 0.0")
 qresult = do_query_number(":CHANnel1:OFFSet?")
 print ("Channel 1 offset: %f" % qresult)

 # Set horizontal scale and offset.
 # 设置水平刻度和偏移
 do_command(":TIMebase:SCALe 10e-6")
 qresult = do_query_string(":TIMebase:SCALe?")
 print ("Timebase scale: %s" % qresult)

 do_command(":TIMebase:POSition 0.0")
 qresult = do_query_string(":TIMebase:POSition?")
 print ("Timebase position: %s" % qresult)

 # Set the acquisition mode.
 # 设置采集模式
 do_command(":ACQuire:MODE RTIMe")
 qresult = do_query_string(":ACQuire:MODE?")
 print ("Acquire mode: %s" % qresult)

 # Or, set up oscilloscope by loading a previously saved setup.
 '''
 sSetup = ""
 f = open("setup.stp", "rb")
 sSetup = f.read()
 f.close()
 do_command_ieee_block(":SYSTem:SETup", sSetup)
 print ("Setup bytes restored: %d" % len(sSetup))
'''
 # Set the desired number of waveform points,
 # and capture an acquisition.
 # 设置所需波形点数和    捕获？
 do_command(":ACQuire:POINts 320000")
 do_command(":DIGitize")


# =========================================================
# Analyze:
# =========================================================
def analyze():

 # Make measurements.
 # 进行测量
 # --------------------------------------------------------
 do_command(":MEASure:SOURce CHANnel1")
 qresult = do_query_string(":MEASure:SOURce?")
 print ("Measure source: %s" % qresult)

 do_command(":MEASure:FREQuency")
 qresult = do_query_string(":MEASure:FREQuency?")
 print ("Measured frequency on channel 1: %s" % qresult)

 do_command(":MEASure:VAMPlitude")
 qresult = do_query_string(":MEASure:VAMPlitude?")
 print ("Measured vertical amplitude on channel 1: %s" % qresult)

 # Download the screen image.
 # 下载屏幕图像。
 # --------------------------------------------------------
 sDisplay = do_query_ieee_block(":DISPlay:DATA? PNG")

 # Save display data values to file.
 f = open("screen_image.png", "wb")
 f.write(sDisplay)
 f.close()
 print ("Screen image written to screen_image.png.")

 # Download waveform data.
 # 下载波形数据。
 # --------------------------------------------------------

 # Get the waveform type.
 # 获取波形类型。
 qresult = do_query_string(":WAVeform:TYPE?")
 print ("Waveform type: %s" % qresult)

 # Get the number of waveform points.
 # 得到波形点的个数。
 qresult = do_query_string(":WAVeform:POINts?")
 print ("Waveform points: %s" % qresult)

 # Set the waveform source.
 # 设置波形源。
 do_command(":WAVeform:SOURce CHANnel1")
 qresult = do_query_string(":WAVeform:SOURce?")
 print ("Waveform source: %s" % qresult)

 # Choose the format of the data returned:
 # 选择数据的格式返回：
 do_command(":WAVeform:FORMat BYTE")
 print ("Waveform format: %s" % do_query_string(":WAVeform:FORMat?"))

 # Display the waveform settings from preamble:
 # 根据 前文？ 显示波形设置
 wav_form_dict = {
  0 : "ASCii",
  1 : "BYTE",
  2 : "WORD",
  3 : "LONG",
  4 : "LONGLONG",
 }
 acq_type_dict = {
  1 : "RAW",
  2 : "AVERage",
  3 : "VHIStogram",
  4 : "HHIStogram",
  6 : "INTerpolate",
  10 : "PDETect",
 }
 acq_mode_dict = {
  0 : "RTIMe",
  1 : "ETIMe",
  3 : "PDETect",
 }
 coupling_dict = {
  0 : "AC",
  1 : "DC",
  2 : "DCFIFTY",
  3 : "LFREJECT",
 }
 units_dict = {
  0 : "UNKNOWN",
  1 : "VOLT",
  2 : "SECOND",
  3 : "CONSTANT",
  4 : "AMP",
  5 : "DECIBEL",
 }

 preamble_string = do_query_string(":WAVeform:PREamble?")
 (
  wav_form, acq_type, wfmpts, avgcnt, x_increment, x_origin,
  x_reference, y_increment, y_origin, y_reference, coupling,
  x_display_range, x_display_origin, y_display_range,
  y_display_origin, date, time, frame_model, acq_mode,
  completion, x_units, y_units, max_bw_limit, min_bw_limit
 ) = preamble_string.split(",")

 print ("Waveform format: %s" % wav_form_dict[int(wav_form)])
 print ("Acquire type: %s" % acq_type_dict[int(acq_type)])
 print ("Waveform points desired: %s" % wfmpts)
 print ("Waveform average count: %s" % avgcnt)
 print ("Waveform X increment: %s" % x_increment)
 print ("Waveform X origin: %s" % x_origin)
 print ("Waveform X reference: %s" % x_reference)   # Always 0.
 print ("Waveform Y increment: %s" % y_increment)
 print ("Waveform Y origin: %s" % y_origin)
 print ("Waveform Y reference: %s" % y_reference)   # Always 0.
 print ("Coupling: %s" % coupling_dict[int(coupling)])
 print ("Waveform X display range: %s" % x_display_range)
 print ("Waveform X display origin: %s" % x_display_origin)
 print ("Waveform Y display range: %s" % y_display_range)
 print ("Waveform Y display origin: %s" % y_display_origin)
 print ("Date: %s" % date)
 print ("Time: %s" % time)
 print ("Frame model #: %s" % frame_model)
 print ("Acquire mode: %s" % acq_mode_dict[int(acq_mode)])
 print ("Completion pct: %s" % completion)
 print ("Waveform X units: %s" % units_dict[int(x_units)])
 print ("Waveform Y units: %s" % units_dict[int(y_units)])
 print ("Max BW limit: %s" % max_bw_limit)
 print ("Min BW limit: %s" % min_bw_limit)

 # Get numeric values for later calculations.
 # 根据后续计算获取数值
 x_increment = do_query_number(":WAVeform:XINCrement?")
 x_origin = do_query_number(":WAVeform:XORigin?")
 y_increment = do_query_number(":WAVeform:YINCrement?")
 y_origin = do_query_number(":WAVeform:YORigin?")

 # Get the waveform data.
 # 获取波形数据
 do_command(":WAVeform:STReaming OFF")
 sData = do_query_ieee_block(":WAVeform:DATA?")

 # Unpack signed byte data.
 # 解压byte数据
 values = struct.unpack("%db" % len(sData), sData)
 print ("Number of data values: %d" % len(values))

 # Save waveform data values to CSV file.
 # 以CSV格式存储波形数据
 f = open("waveform_data.csv", "w")

 for i in range(0, len(values) - 1):
  time_val = x_origin + (i * x_increment)
  voltage = (values[i] * y_increment) + y_origin
  f.write("%E, %f\n" % (time_val, voltage))
 
 f.close()
 print ("Waveform format BYTE data written to waveform_data.csv.")


# =========================================================
# Send a command and check for errors:
# 发送数据并检查errors
# =========================================================
def do_command(command, hide_params=False):

 if hide_params:
  (header, data) = string.split(command, " ", 1)
  if debug:
   print ("\nCmd = '%s'" % header)
 else:
  if debug:
   print ("\nCmd = '%s'" % command)

 Infiniium.write("%s" % command)

 if hide_params:
  check_instrument_errors(header)
 else:
  check_instrument_errors(command)



# =========================================================
# Send a query, check for errors, return string:
# 发送一个查询，检查errors，返回字符串
# =========================================================
def do_query_string(query):
 if debug:
  print ("Qys = '%s'" % query)
 result = Infiniium.query("%s" % query)
 check_instrument_errors(query)
 return result


# =========================================================
# Send a query, check for errors, return floating-point value:
# 发送一个查询，检查errors，返回浮点值
# =========================================================
def do_query_number(query):
 if debug:
  print ("Qyn = '%s'" % query)
 results = Infiniium.query("%s" % query)
 check_instrument_errors(query)
 return float(results)


# =========================================================
# Send a query, check for errors, return binary values:
# 发送一个查询,检查errors，返回二进制值
# =========================================================
def do_query_ieee_block(query):
 if debug:
  print ("Qyb = '%s'" % query)
 result = Infiniium.query_binary_values("%s" % query, datatype='s')
 check_instrument_errors(query)
 return result[0]


# =========================================================
# Check for instrument errors:
# 检查仪器errors
# =========================================================
def check_instrument_errors(command):

 while True:
  error_string = Infiniium.query(":SYSTem:ERRor? STRing")
  if error_string:   # If there is an error string value.

   if error_string.find("0,", 0, 2) == -1:   # Not "No error".

    print ("ERROR: %s, command: '%s'" % (error_string, command))
    print ("Exited because of error.")
    sys.exit(1)

   else:   # "No error"
    break
 
  else:   # :SYSTem:ERRor? STRing should always return string.
   print ("ERROR: :SYSTem:ERRor? STRing returned nothing, command: '%s'" % command)
   print ("Exited because of error.")
   sys.exit(1)


# =========================================================
# Main program:
# 主函数
# =========================================================

rm = visa.ResourceManager()
Infiniium = rm.open_resource("USB0::0x2A8D::0x904B::MY54200104::0::INSTR")

Infiniium.timeout = 20000
Infiniium.clear()

# Initialize the oscilloscope, capture data, and analyze.
# 初始化示波器，捕获数据，并分析
initialize()
capture()
analyze()

print ("End of program.")
