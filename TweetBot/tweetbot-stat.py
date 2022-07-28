    #!/usr/bin/env python2.7  
    # twitterwin.py by Alex Eames http://raspi.tv/?p=5281  
    import tweepy  
    import random  
      
    # Consumer keys and access tokens, used for OAuth  
    consumer_key = https://apps.twitter.com/app/12308028/keys  
    consumer_secret = sxOtLHJ11eY7ktMCxcyTBOvz0enlav1un2oEv3a8CZr5vSBDBc  
    access_token = 125080809-uWxW3Nagnqi73shyrL0yKlZDPlJHc9gIMBuNlF5H
    access_token_secret = YT97q0Ty0tRP2om0zLSSAOnrt8ih5BrUEpdAIq2wj5JAI 
      
    # OAuth process, using the keys and tokens  
    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)  
    auth.set_access_token(access_token, access_token_secret)  
      
    # Creation of the actual interface, using authentication  
    api = tweepy.API(auth)  
      
    follow2 = api.followers_ids() # gives a list of followers ids  
    print "you have %d followers" % len(follow2)  
      
    show_list = raw_input("Do you want to list the followers array?")  
    if show_list in ('y', 'yes', 'Y', 'Yes', 'YES'):  
        print follow2  
      
    def pick_winner():  
        random_number = random.randint(0, len(follow2)-1)  
        winner = api.get_user(follow2[random_number])  
        print winner.screen_name, random_number  
      
    while True:  
        pick = raw_input("Press Enter to pick a winner, Q to quit.")  
        if pick in ('q', 'Q','quit', 'QUIT', 'Quit'):  
            break  
        pick_winner()  