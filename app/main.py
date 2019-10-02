from flask import Flask, request
import os

app = Flask( __name__ )
port=os.environ.get('PORT')

@app.route( '/', methods=['POST', 'GET'])
def handle_request():
    return "Hello World, listening on: " + port

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=False, port=port)
