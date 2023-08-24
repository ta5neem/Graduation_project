# import mysql.connector
# import pymssql
# from sqlalchemy import create_engine
from django.db.models import Count
from django.http import JsonResponse
import os
import django
import sys
import sys
import os
from django.db import connections
from django.conf import settings
from django.shortcuts import render
from asgiref.sync import sync_to_async
from datetime import date
import sqlite3
import requests
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth import get_user
# from channels.routing import ProtocolTypeRouter, URLRouter
# from myapp.middleware import UserMiddleware
from django.urls import path
# from myapp import consumers
from django.contrib.auth import get_user_model
from django.test import Client, TestCase
# from crequest.middleware import CrequestMiddleware
from django.contrib.sessions.backends.db import SessionStore
from django.http import HttpResponse
import os
import django

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "projectapp.settings")
django.setup()

from .models import User
# from evaluation.models import Video
from django.shortcuts import get_object_or_404

from evaluation.models import Video, Evaluation, HandEval


outer_folder_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'evaluation'))
# Add the outer folder path to sys.path
sys.path.append(outer_folder_path)
import os
import django

# # Set the DJANGO_SETTINGS_MODULE environment variable
# os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'your_project_name.settings')

# # Configure Django settings
# django.setup()



user_id = None 

class DataBase : 
    
    mycursor =None
    
    


    def is_user_logged_in():
        print( "loggggged in ?"+ str('User.objects.filter(ifLogged=True).exists()'))
        return User.objects.filter(ifLogged=True).exists()


    def set_user(request):
        global user_id
        user_id = 2
        
        print ( "nkhkjhljljjljl")
        return HttpResponse("User set successfully")
        


    def get_tables(path) : 
        conn = sqlite3.connect(path)
        cursor = conn.cursor()
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cursor.fetchall()
        # Print the table names
        for table in tables:
            print(table[0])
        # print("the user Id" + str(self.user_id))
        # # Close the connection
        # # conn.close()
        


        conn.commit()
        conn.close()    

        print ("done")

 
        



    def get_cols_name(path):
        conn = sqlite3.connect(path)
        cursor = conn.cursor() 
        cursor.execute("PRAGMA table_info(evaluation_evaluation)")
        columns = cursor.fetchall()

        # Print the column names
        for column in columns:
            column_name = column[1]
            print(column_name)
        
        conn.commit()
        conn.close()    


   

    def is_user_logged_in(self):
        return User.objects.filter(ifLogged=True).exists()



    def store_vedio_cols( path, size, time, title , id):
        # User is logged in, proceed with storing the video columns
        # user = User.objects.get(ifLogged=True)
        # print("user typepepe " + str (user.id) + " ddd" +str(type(user.id)))
        conn = sqlite3.connect(path)
        cursor = conn.cursor()
        current_date = date.today()
        print(current_date)
        cursor.execute("INSERT INTO evaluation_video (size, time, title, date, user_id_id) VALUES (?, ?, ?, ?, ?)",
                    (size, time, title, current_date, id))
        conn.commit()
        conn.close()
    


    def eval_from_10( value,from_): 
        eval_from_10_= 10 - ((value * 10) /from_ )
        return eval_from_10_
    

    def store_Eval_cols(path,motion_count) : 
        conn = sqlite3.connect(path)
        cursor = conn.cursor()



    @csrf_exempt
    def get_user_information(request):
        user_id = request.session.get('user_id', 0)

        # Convert the index to an integer

        user = User.objects.filter(id=user_id).values()  # Use 'id' instead of 'user_id'

        return JsonResponse(list(user), safe=False) 





    @csrf_exempt
    def get_all_vedio_of_user(request):
        specific_user_id = request.session.get('user_id', 0)
        video_count = Video.objects.filter(user_id=specific_user_id).count()
        
        response_data = {'video_count': video_count}
        return JsonResponse(response_data)

    @csrf_exempt
    def get_specific_video_and_evaluation(request):
        user_id = request.session.get('user_id', 0)

        video_index = int(request.POST.get('video_index', 0))

        print  ('video_index' + str (video_index))
          # Convert the index to an integer

        videos_for_user = Video.objects.filter(user_id=user_id)

        if 0 <= video_index < len(videos_for_user):
            specific_video = videos_for_user[video_index]
        else:
            return JsonResponse({'message': 'Invalid video index'}, status=404)

        video_data = {
            'size': specific_video.size,
            'time': specific_video.time,
            'title': specific_video.title,
            'date': specific_video.date,
        }

        evaluation_data = {
            'total_eval': specific_video.evaluation.total_eval,
            'hand_eval': {
                'CLOSED_U_HANDS': specific_video.evaluation.handeval.CLOSED_U_HANDS,
                'HAND_CROSSED': specific_video.evaluation.handeval.HAND_CROSSED,
                'HAND_ON_HIP': specific_video.evaluation.handeval.HAND_ON_HIP,
                'HAND_ON_HEAD': specific_video.evaluation.handeval.HAND_ON_HEAD,
                'STRAIGHT_DOWN': specific_video.evaluation.handeval.STRAIGHT_DOWN,
                'CLOSED_D_HANDS': specific_video.evaluation.handeval.CLOSED_D_HANDS,
                'OUT_BOX': specific_video.evaluation.handeval.OUT_BOX,
                'CORRECT_MOTION': specific_video.evaluation.handeval.CORRECT_MOTION,
                'ON_SIDE': specific_video.evaluation.handeval.ON_SIDE,
                'VIBRATING_MOTION': specific_video.evaluation.handeval.VIBRATING_MOTION,
            }
        }

        response_data = {
            'video_data': video_data,
            'evaluation_data': evaluation_data,
        }

        return JsonResponse(response_data)

    def store_Hands_cols(path,motion_data,total_time):
        conn = sqlite3.connect(path)
        cursor = conn.cursor()

        thresh = 8 
        from_ = total_time / thresh
        
        CLOSED_U_HANDS = motion_data['CLOSED_U_HANDS']['count']
        HAND_CROSSED = motion_data['HAND_CROSSED']['count']
        HAND_ON_HIP = motion_data['HAND_ON_HIP']['count']
        HAND_ON_HEAD = motion_data['HAND_ON_HEAD']['count']
        STRAIGHT_DOWN = motion_data['STRAIGHT_DOWN']['count']
        CLOSED_D_HANDS = motion_data['CLOSED_D_HANDS']['count']
        OUT_BOX = motion_data['HANDS_OUT_BOX']['count']
        CORRECT_MOTION = motion_data['CORRECT_MOTION']['count'] 
        VIBRATING_MOTION = motion_data['VIBRATING_MOTION']['count']
        ON_SIDE = motion_data['ON_SIDE']['count']

        print ( "CLOSED_U_HANDS " +str (CORRECT_MOTION) )
        # Execute a SELECT query to get the last ID in the specific table
        cursor.execute("SELECT id FROM evaluation_evaluation ORDER BY id DESC LIMIT 1")
        # Fetch the result
        result = cursor.fetchone()
        last_id = result[0] if result else 0
        print ("the last " + str(last_id)) 
        evaluation_id = last_id+1
        current_date = date.today()
        print(current_date)
        global user_id
        user_id_ = user_id
        cursor.execute("INSERT INTO evaluation_handeval (CLOSED_U_HANDS, HAND_CROSSED, HAND_ON_HIP , HAND_ON_HEAD ,STRAIGHT_DOWN , CLOSED_D_HANDS ,OUT_BOX ,CORRECT_MOTION ,ON_SIDE , VIBRATING_MOTION ,evaluation_id_id) VALUES (?,?,?,?, ?, ? ,? ,? ,?,?,?)", \
                       (CLOSED_U_HANDS, HAND_CROSSED, HAND_ON_HIP , HAND_ON_HEAD ,STRAIGHT_DOWN , CLOSED_D_HANDS ,OUT_BOX ,CORRECT_MOTION ,ON_SIDE , VIBRATING_MOTION  ,evaluation_id) )

        cursor.execute("SELECT id FROM evaluation_video ORDER BY id DESC LIMIT 1")
        result = cursor.fetchone()
        last_id = result[0] if result else None
        print ("the last " + str(last_id)) 
        total_eval = 10- (HAND_ON_HEAD+HAND_CROSSED+ HAND_ON_HIP +STRAIGHT_DOWN +CLOSED_U_HANDS+OUT_BOX +CLOSED_D_HANDS)/7

        cursor.execute("INSERT INTO evaluation_evaluation (total_eval ,video_id_id) VALUES (?,?)", (total_eval ,last_id) )
        conn.commit()
        conn.close()   
        


    def get_hand_evals(self,id):

        # query = "SELECT * FROM hand_evaluation WHERE evaluation_id = (SELECT id FROM evaluation WHERE video_id = 2)"
        id = "select * from hand_evals where id='%s'" % (id)
        self.mycursor.execute(id)
        id = self.mycursor.fetchall()

        sql = "select * from face_evals where id =  (%s)" % (id[0][0])
        self. mycursor.execute(sql)
        myresult = self.mycursor.fetchall()
        print (myresult)



         


