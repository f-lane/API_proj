# This contains the API endpoints.
from flask import Flask, jsonify, request
from db_utils import all_results, submit_result, get_daily_results

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Welcome to the Running Club!'

@app.route('/results')
def all():
    res = all_results()
    return jsonify(res)

@app.route('/submit', methods=['POST'])
def add_new_result():
    submission = request.get_json()
    submit_result(
        runnerName=submission['runnerName'],
        date=submission['date'],
        time=submission['time'],
        distance=submission['distance'],
    )
    print(submission)
    return submission

@app.route('/results/<date>')
def get_results(date):
    res = get_daily_results(date)
    return jsonify(res)

if __name__ == '__main__':
    app.run(debug=True, port=5001)