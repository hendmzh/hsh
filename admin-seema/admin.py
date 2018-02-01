from flask import Flask, flash, redirect, render_template, request, session, abort, url_for
import os

app = Flask(__name__)


@app.route('/')
def main():
    if not session.get('logged_in'):
        return render_template('login.html')
    else:
        return render_template('index.html')

@app.route('/login', methods=['POST'])
def do_admin_login():
    if request.form['password'] == 'password' and request.form['username'] == 'admin':
        session['logged_in'] = True
    else:
        flash('wrong password!')
    return main()

@app.route("/logout")
def logout():
    session['logged_in'] = False
    return main()


@app.route('/light', methods=['POST', 'GET'])
def hello_world():
    # variables for template page (templates/index.html)
    author = "Kyle"
    readval = 10

    # if we make a post request on the webpage aka press button then do stuff
    if request.method == 'POST':

        # if we press the turn on button
        if request.form['submit'] == 'Turn On':
            print('TURN ON')

        # if we press the turn off button
        elif request.form['submit'] == 'Turn Off':
            print('TURN OFF')

        else:
            pass

    # the default page to display will be our template with our template variables
    return render_template('light.html', author=author, value=100 * (readval / 1023.))




@app.route('/newuser')
def new_user():
    return render_template('newuser.html')

@app.route('/newroom')
def new_room():
    return render_template('newroom.html')

@app.route('/newapplience')
def new_applience():
    return render_template('newapplience.html')

@app.route('/newdoor')
def new_door():
    return render_template('newdoor.html')




if __name__ == "__main__":
    app.secret_key = os.urandom(12)
    app.run()

