from .PoseDetector import PoseDetector
from .more_functions import more_functions
from .fuzzy_evaluation import total_evaluation_using_fuzzy_sys
from .motion import motion
# import motion
import math
import cv2
import mediapipe as mp
import numpy as np
from experta import *
from enum import Enum
# import mysql.connector
# import pymssql
from sqlalchemy import create_engine
from .connection_database import DataBase
import time
import os
from django.http import JsonResponse

from flask import Flask, request, jsonify, render_template, Response
from flask_cors import CORS, cross_origin
from flask_socketio import SocketIO, emit
from django.views.decorators.csrf import csrf_exempt
import time
import plotly.graph_objects as go
from PIL import Image
from tkinter import Tk, Label, Canvas, NW
from PIL import ImageTk
from django.middleware import csrf
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
import os
import requests
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import base64
import json
# from .views import store 
# import django


app = Flask(__name__)
cors = CORS(app)
app.config['SECRET_KEY'] = 'secret!'
app.config['CORS_HEADERS'] = 'Content-Type'
app.config['CORS_SUPPORTS_CREDENTIALS'] = True
socketio = SocketIO(app, cors_allowed_origins="*")

ALLOWED_HOSTS = ['*']
ALLOWED_IP = ['*']

# path = r'D:\Newfolder\Desktop\linked_model\model_pro\loginlogout\..\db.sqlite3'

# class Globals:
#     var = 5000

# global_elapsed_time = None 
# global_frame_count = 0
# global_motion_count = []
more = more_functions()



@csrf_exempt
def run_with_soket(request):
    print('socket')
    socketio.run(app, host='192.168.186.78', port=8080)


x_var =0

def check_value(result):
    global x_var
    #لا يوجد خطأ
    if result[0] == 'CORRECT_MOTION':
        # print ( 'CORRECT_MOTION tuple tuple' + str ( result[1]  ))
        # print ( result[0] )
        x_var=(x_var+ result[1])
        return x_var
    else:
        x_var=(x_var - result[1])
        return x_var


   

    # cv2.imshow("plot",image)
    


def process_list(lst, result,prev_char , z ):
    if lst == prev_char:
        result.append((lst, 0.5))
        z = 0.5
    else:
        prev_char = lst
        result.append((lst,0.5))
        z= 0.5

    return result,prev_char ,z

# مثال للاختبار
gl_elapsed_time ,gl_frame_count ,gl_motions_array ,gl_count_sin =0 ,0 ,[], 0 

def set_global_variables(elapsed_time, frame_count, motions_array, count_sin):
    global gl_elapsed_time, gl_frame_count, gl_motions_array, gl_count_sin
    gl_elapsed_time = elapsed_time
    gl_frame_count = frame_count
    gl_motions_array = motions_array
    gl_count_sin = count_sin
    print ( gl_elapsed_time , gl_frame_count ,gl_motions_array ,gl_count_sin)

# def handle_test(request):
# @socketio.on('test')


def draw(angle , fig ):
    x_data =  list(fig['data'][0]['x'])  
    y_data = list(fig['data'][0]['y'])  
    
    #x_data.append(len(x_data))
    x_data.append(time.time())  # إضافة الإحداثيات الجديدة
    y_data.append(check_value(angle))

    # تحديث بيانات الرسم البياني
    fig.update_traces(x=x_data, y=y_data)

    # تحديث الإعدادات للحفاظ على الحد الأقصى للنقاط المعروضة
    max_points = 100  # عدد النقاط المطلوب عرضها
    if len(x_data) > max_points:
        x_data = x_data[-max_points:]
        y_data = y_data[-max_points:]

    # تحديث البيانات في الرسم البياني
    fig.update_layout(autosize=False, width=400, height=400)
    fig.update_xaxes(range=[fig['data'][0]['x'], time.time() +20]) 
    # fig.update_xaxes(range=[time.time() -30 , time.time() +30])
    #fig.show()
    
    # حفظ المخطط كملف صورة
    fig.write_image("plot.png")

    # عرض المخطط كصورة باستخدام PIL
    image = cv2.imread("plot.png")
    return image

import requests


@csrf_exempt
def send_image(request):
    if request.method == 'POST':
        script_directory = os.path.dirname(os.path.abspath(__file__))
        # Calculate the path to the image file based on the script's directory
        image_path = os.path.join(script_directory, '..', 'plot.png')

        api_url = "http://127.0.0.1:8000/api/upload_image"

        # Create a dictionary to represent the data payload
        csrf_token = csrf.get_token(request)

        # Prepare data and files for the request
        data = {
            "key1": "value1",
            "key2": "value2",
        }

        with open(image_path, "rb") as image_file:
            files = {'image': (image_file.name, image_file, 'image/jpeg')}

            # Include CSRF token in headers
            headers = {"X-CSRFToken": csrf_token}

            # Send the POST request with CSRF token in headers
            response = requests.post(api_url, data=data, files=files, headers=headers)

            # Process the response
            response_data = {
                "status_code": response.status_code,
                "response_text": response.text,
            }

            # Parse the response JSON
            response_json = json.loads(response.text)
            image_data = response_json.get("image_data")

            if image_data:
                # Decode the base64 image data and save/process it as needed
                decoded_image_data = base64.b64decode(image_data)
                # Handle the decoded image data as per your requirement

            response_data["image_data"] = image_data  # Add image_data to response_data

        return JsonResponse(response_data)
                




@csrf_exempt
def main(request):
    print('main')
    # Get the directory of the script




    # ###هاد لتابع الرسم صور 
    fig = go.Figure()
    fig.add_trace(go.Scatter(x=[], y=[], mode='lines', name='Angle'))
 
    detector = PoseDetector()

    cap = cv2.VideoCapture(0)
    global frame_count
    frame_count=0

    #تعريف متغير مصفوفة الحركات : 
    motion_in_secound_array= [] 
    # global motions_array
    motions_array = []
    start_time = time.time()
    sholder_points = []
    # con_time = time.time()
    is_sin = False
    correct_var =None
    best_DTW = None
    prev_frame = None
    prevent_repeate = 0
    frames_landmarks = []
    evaluation_array = [] 
    result = [] 
    prev_char = None 
    z = 1 
    count_sin =0
    thresh = 8 
    prev_motion = None


    motion_notes = {
    'HAND_ON_HEAD': " Try not to focus in the audience , Get your hand off your face . :on_head",
    'HAND_CROSSED': "Try to communicate with the audience Your hands are folded , don't stay like that for long. : ",
    'HAND_ON_HIP': " You look controlling , take a breath , move your hands calmly , and communicate with the audience . :hand_on_waist ",
    'STRAIGHT_DOWN': "Take a deep breath and try to move as you are , You look fear . :handdown ",
    'CLOSED_U_HANDS': "Try to relax by putting your hands down for a few seconds , you look nervous. :handcrossed2",
    'CLOSED_D_HANDS': "Try to raise and move your hands a little , You look not confident . :handcross ",
    'OUT_BOX': "Calm down , you open your hands a lot . :zone ",
    'CORRECT_MOTION': "Keep going .. : ok ",
    'ON_SIDE' : "Turn your body to the audience , You lose contact with the audience . :side " ,
    'VIBRATING_MOTION' : "Try to take regular breaths , you seem a little tense . : "
}
    
   

    
    keypoints = []
    while cap.isOpened():
        try : 
            frame_count=frame_count+1
            if frame_count%1==0:
                # frame_count=0
                success, image = cap.read()
                get_note = False
                gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
                
                image = cv2.flip(image,1)
                blackie = np.zeros(image.shape) # Black image
                image,blackie = detector.find_pose(image ,blackie)
                h, w = image.shape[:2]
                detector.Landmark_pos(w,h)
                
                image = more.draw_img(image,
                            str(more.angle_between_points(detector.R_sholder, detector.R_elbow, detector.R_wrist)),
                                [100,100])
                more.draw_img(blackie,
                            str(more.angle_between_points(detector.R_sholder, detector.R_elbow, detector.R_wrist)),
                                [100,100])
                      #اخذ نقاط الكتف لاستخدامها في كشف الاهتزاز 
                if detector.R_sholder is None :
                        print ('NONEEE')
                else : 
                    sholder_points.append(detector.R_sholder)
                
                variable ,image , blackie =more.expertsys(image, blackie , detector)
                #اضافة الحركة الى المصفوفة تبع الحركات 
                try :
                    par_time = time.time() 
                    partly_time = par_time - start_time
                    
                    if variable is not None :  
                        # motion_in_secound_array.append(variable.name)
                        tupl = (variable.name ,detector.return_keypoints() )
                        frames_landmarks.append(tupl)
                    else :  
                        # motion_in_secound_array.append(variable.name)
                        tupl = (motion.CORRECT_MOTION.name ,detector.return_keypoints() )
                        frames_landmarks.append(tupl)
                        

                    if int(partly_time)%1 ==0 and prevent_repeate != int(partly_time):
                        par_time = time.time() 
                        partly_time = par_time - start_time
                         
                        most_similar_landmark_tuple = more.find_most_similar_landmarks(frames_landmarks)
                        correct_var, most_similar_landmarks = most_similar_landmark_tuple
                        
                        best_DTW = more.calculate_dtw_distance(frames_landmarks)
                        
                        # correct_var = more.spatial_analysis(frames_landmarks)
                        cv2.putText(blackie ,"spatial var" + str(correct_var) ,(25,100),cv2.FONT_HERSHEY_PLAIN,2,(255,99,0),2)
                        # cv2.putText(blackie ,"DTW var" + str(best_DTW) ,(25,130),cv2.FONT_HERSHEY_PLAIN,2,(255,99,0),2)
                        motions_array.append(correct_var)
     
                        frames_landmarks = []

                                                
                        if  len(motions_array) >= thresh :
                            check_state_result=more.check_state(motions_array)
                            # print (check_state_result)
                            
                            
                            if check_state_result:
                                evaluation_array.append(motions_array[-1])
                                result, prev_char, z = process_list(evaluation_array[-1], result, prev_char, z)

                                current_motion = motions_array[-1]
                                if current_motion != prev_motion:
                                    get_note = True
                                    motion_note = motion_notes.get(current_motion, None)
                                    if motion_note:
                                        ###########################
                                        #emit here 
                                        print(motion_note)
                                        ###########################
                                        
                                    prev_motion = current_motion

                         
                            else :
                                evaluation_array.append(motion.CORRECT_MOTION.name)
                                result,prev_char , z = process_list(evaluation_array[-1],result,prev_char ,z)
                                # print("fggggggr" + str(result))

                                 
                            image2 = draw(result[-1],fig)
                            cv2.imshow("plot",image2)


                    if int(partly_time)% thresh ==0 and prevent_repeate != int(partly_time): 
                        con_time = int(partly_time)
                        newPoint_sholder = more.plot_periodic_signal(sholder_points, time_step=0.0001)
                        
                        newPoint_sholder = more.plot_periodic_signal(newPoint_sholder, time_step=0.0001)
                        
                        is_sin =  more.is_sin_signal(newPoint_sholder)
                        if is_sin : 
                            count_sin += 1
                            if not get_note : 
                                motion_note = motion_notes.get('VIBRATING_MOTION', None) 
                                print (motion_note)
                        cv2.putText(blackie ,"isssssss periodic ?   " + str(is_sin) ,(25,25),cv2.FONT_HERSHEY_PLAIN,2,(255,99,0),2)
                        sholder_points = []


                            

                    cv2.putText(blackie, "isssssss periodic ?   " + str(is_sin), (25, 25), cv2.FONT_HERSHEY_PLAIN, 2, (255, 99, 0), 2)
                    cv2.putText(blackie ,"spatial var" + str(correct_var) ,(25,100),cv2.FONT_HERSHEY_PLAIN,2,(255,99,0),2)
                    # cv2.putText(blackie ,"DTW var" + str(best_DTW) ,(25,130),cv2.FONT_HERSHEY_PLAIN,2,(255,99,0),2)


                    prevent_repeate = int(partly_time)
                except Exception as e:

                    print('error:', e)


                cv2.putText(blackie,str(variable),(100,400),cv2.FONT_HERSHEY_PLAIN,2,(255,99,0),2)
                
                cv2.imshow("blackie", blackie)
                cv2.imshow("Image", image)
                # cv2.imshow("plot",image2)
                cv2.waitKey(1)
                if not success:
                    break
            
            prev_frame = gray.copy()

            if cv2.waitKey(1) == ord('q') or cv2.waitKey(1) == ord('×'):
                            break   
        except Exception as e:
            success, image = cap.read()
            gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)            
            image = cv2.flip(image,1)
            blackie = np.zeros(image.shape)
            cv2.imshow("blackie", blackie)
            cv2.imshow("Image", image)
            # if e   == str ( )'NoneType' object has no attribute 'landmark' : 
            # 'NoneType' object has no attribute 'landmark'
            print('Error:', e)

    cap.release()
    cv2.destroyAllWindows()
    # root.mainloop()
    # root.destroy()


    end_time = time.time()
    # global elapsed_time
    elapsed_time = end_time - start_time

    print(motions_array)
    print (elapsed_time, frame_count, motions_array, count_sin)
    set_global_variables(elapsed_time, frame_count, motions_array, count_sin)

    

    # #حساب التقييم لكل حركة 
    thresh = 8 
   
    return JsonResponse({"message": "Continuous processing started."})









@csrf_exempt
def show_eval(request):
    # Get session values
    script_directory = os.path.dirname(os.path.abspath(__file__))
    # Calculate the path to db.sqlite3 based on the script's directory
    db_path = os.path.join(script_directory, '..', 'db.sqlite3')
    # print("Path to db.sqlite3:", db_path)
    path = f'{db_path}'

    global gl_elapsed_time
    elapsed_time = gl_elapsed_time

    global gl_frame_count
    frame_count = gl_frame_count
    # gl_frame_count = frame_count
    global gl_motions_array
    motions_array = gl_motions_array
    # gl_motions_array = motions_array
    global gl_count_sin
    count_sin = gl_count_sin

    print(elapsed_time, frame_count, motions_array, count_sin)

    id = request.session.get('user_id', 0)


    # print  ( " the id isisisisisisisis" + str (id))
    # Calculate sine-related values
    thresh = 8
    from_sin = elapsed_time / thresh
    true_sin = 0
    false_sin = elapsed_time - count_sin
    from_ = 0

    if count_sin > 0:
        true_sin = math.log(count_sin * 10)
    if false_sin > 0:
        false_sin = math.log(false_sin * 10)

    from_sin = true_sin + false_sin

    try : 
        periodical = ((true_sin * 10) / from_sin)
    except :
            periodical= 0

    # Calculate motion evaluations
    motion_count = more.motions_evaluations(motions_array, thresh)

    # print ( 'the motion array iss' + str (motions_array)  )

    # Calculate total 'from_' value (same as before)
    from_ = 0
    for key, value in motion_count.items():
        if key is not None:
            from_ += value

    # Initialize motion counters and notes in a single dictionary
    motion_data = {
        'HAND_ON_HEAD': {'count': 0, 'note': "Don't put your hand on your face It is important to keep your facial \
expressions visible to the audience, as this indicates that you are \
feeling nervous and making an unwanted impression.."},
       
        'HAND_CROSSED': {'count': 0, 'note': "Don't keep your hands folded. \
This position may be understood as disinterested and reserved an \
may be interpreted as defensive behavior, especially if accompanied \
by avoiding direct gaze and this may show a lack of desire to communicate.."},
      
      
        'HAND_ON_HIP': {'count': 0, 'note': "Don't keep your hands on your waist \
This indicates a symbol of control and that you are in a state of \
caution and attention. This behavior can show that you are assessing \the situation and may cause the audience to be uncomfortable."},

        'STRAIGHT_DOWN': {'count': 0, 'note': "Don't keep your hands at your sides \
This conveys a sense of stress or uneasiness. Try to gently ease this \
movement, and let your hands loosen up a bit to allow yourself to express naturally."},

        'CLOSED_U_HANDS': {'count': 0, 'note': "Don't keep your hands crossed \
This indicates a lack of openness and your inability to \
express and interact, and it may indicate your desire to \
protect or warn others, and the audience can interpret this \
behavior as being unsure of the environment around you."},

        'CLOSED_D_HANDS': {'count': 0, 'note': "Don't keep your hands in front of your groin area\
When you spend too much time clasping your hands in front of your \
groin area it indicates not knowing what to do or say and getting attention with tension."},

        'HANDS_OUT_BOX': {'count': 0, 'note': " Keep your hands in 'strike zone' as possible \
This is a natural area for hand gestures because stepping out \
 of this area can be distracting to the audience."},
        
        'CORRECT_MOTION': {'count': 0, 'note': ''},
        
        'ON_SIDE': {'count': 0, 'note': "You lean to the side, return your body to the audience\
When you lean in too much, it may show unease or distrust of the current situation. It's a good idea to turn towards the audience and maintain eye contact"},
        
        'VIBRATING_MOTION': {'count': periodical, 'note': "Don't shake too much \
This indicates that you are nervous. Try to think about the content of the show and communicate with the audience to calm yourself down"},
    }

    # Calculate motion counters (same as before)
    for key, value in motion_count.items():
        if key in motion_data and value is not None:
            motion_data[key]['count'] += (value * 10) / from_



    notes = []
    for motion, data in motion_data.items():
        if data['count'] > 1.5:
            note = data['note'].format(counter_value=data['count'])
            notes.append(f"{motion}: Count={data['count']:.2f}, Note: {note}")
        else:
            notes.append(f"{motion}: Count={data['count']:.2f}, Note: ")

    # total_eval = total_evaluation_using_fuzzy_sys ()    

    counts = {motion: data['count'] for motion, data in motion_data.items()}
    total_eval = total_evaluation_using_fuzzy_sys ( counts) 

    DataBase.store_vedio_cols(path ,frame_count,int(elapsed_time),1 ,id )
    DataBase.store_Hands_cols(path,motion_data,elapsed_time)


    return JsonResponse({'total_eval': total_eval, 'notes': notes  })









if __name__ == "__main__":
    # print("iddddd" +str(connection_database.user_id))
    # socketio.run(app, host='192.168.43.83', port=8080)
    main()
    # connection_database.DataBase.get_cols_name(path)
    
