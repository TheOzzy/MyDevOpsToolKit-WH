import os
from flask import Flask, render_template_string
import redis

app = Flask(__name__)
redis_host = os.getenv('REDIS_HOST', 'redis') 
redis_port = int(os.getenv('REDIS_PORT', 6379))
cache = redis.Redis(redis_host, redis_port, decode_responses=True)

HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>In-File Homepage</title>
</head>
<body>
    
    <h1>Hello, welcome to the homepage</h1>
    <br>
    <p>Select the following to access the count page <a href="/count"> Count Page! </a></p>
</body>
</html>
"""

HTML_COUNT = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>In-File Template</title>
</head>
<body>
    <h1> Welcome to the count page as part of the docker challenge</h1>
    <br>
    <p> You've visted this site --> {{count}} 
</body>
"""

@app.route('/')
def index():
    
    # Render the string directly with the context data
    return render_template_string(
        HTML_TEMPLATE, 
    )


@app.route('/count')
def count():

    hits = 0

    try:
       
        current_hits = cache.incr(hits)
    except redis.exceptions.ConnectionError:
        current_hits = "Error: Database Offline"
        
    return render_template_string(HTML_COUNT, count=current_hits)
    

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000,debug=True)
