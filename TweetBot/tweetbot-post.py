from __future__ import print_function #Allows python3 use of print()
import string
import tweepy
import os
import sys

# Consumer keys and access tokens, used for OAuth  
consumer_key = 'p3x9AkF8l2kpypumQ5vghNS6g'  
consumer_secret = 'sxOtLHJ11eY7ktMCxcyTBOvz0enlav1un2oEv3a8CZr5vSBDBc'  
access_token = '125080809-uWxW3Nagnqi73shyrL0yKlZDPlJHc9gIMBuNlF5H'
access_token_secret = 'YT97q0Ty0tRP2om0zLSSAOnrt8ih5BrUEpdAIq2wj5JAI'

# OAuth process, using the keys and tokens
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

# Creation of the actual interface, using authentication
api = tweepy.API(auth)


## This function sends the tweets. It will check the length of them first of all.      

from sys import argv

script, post = argv

def sendTweet(post):
	api.update_status(status=post) 
	#print (post) #Use for debugging
sendTweet(post)
