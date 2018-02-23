from flask import Flask, flash, redirect, render_template, request, session, abort, url_for, jsonify
import os
from pyduino import *
import time
from models import User, Base, Room, Appliance, Door
from forms import UserForm, RoomForm, ApplianceForm
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from flask_restful import reqparse, abort, Api, Resource

app = Flask(__name__)
api = Api(app)
engine = create_engine('sqlite:///admin.db')
Base.metadata.bind = engine
DBSession = sessionmaker(bind=engine)
db_session = DBSession()


# initialize connection to Arduino
# if your arduino was running on a serial port other than '/dev/ttyACM0/'
# declare: a = Arduino(serial_port='/dev/ttyXXXX')
#a = Arduino()
#time.sleep(3)

# declare the pins we're using
#LED_PIN = 3
#ANALOG_PIN = 0

# initialize the digital pin as output
#a.set_pin_mode(LED_PIN,'O')

#print('Arduino initialized')


@app.route('/')
def main():
    if not session.get('logged_in'):
        return render_template('login.html')
    else:
        return render_template('index.html')

@app.route('/login', methods=['POST'])
def do_admin_login():
    if request.form['password'] == '1' and request.form['username'] == 'admin':
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
    author = "Home Smart Home"
    readval = 10

    # if we make a post request on the webpage aka press button then do stuff
    if request.method == 'POST':

        # if we press the turn on button
        if request.form['submit'] == 'Turn On':
            print('TURN ON')
            # turn on LED on arduino
            a.digital_write(LED_PIN,1)

        # if we press the turn off button
        elif request.form['submit'] == 'Turn Off':
            print('TURN OFF')
            # turn off LED on arduino
            a.digital_write(LED_PIN,0)

        else:
            pass

    # read in analog value from photoresistor
    readval = a.analog_read(ANALOG_PIN)
                    
    # the default page to display will be our template with our template variables
    return render_template('light.html', author=author, value=100 * (readval / 1023.))


# unsecure API urls
@app.route('/turnon', methods=['GET'] )
def turn_on():
    # turn on LED on arduino
    a.digital_write(LED_PIN,1)
    return redirect( url_for('hello_world') )


@app.route('/turnoff', methods=['GET'] )
def turn_off():
    # turn off LED on arduino
    a.digital_write(LED_PIN,0)
    return redirect( url_for('hello_world') )

 
@app.route("/newuser", methods=['GET', 'POST'])
def new_user():
    form = UserForm(request.form)
 
    print form.errors
    if request.method == 'POST':
        FName=request.form['FName']
        LName=request.form['LName']
        Username=request.form['Username']
        Email=request.form['Email']
        Password=request.form['Password']
        Gender=request.form['Gender']
        EmergencyPhone=request.form['EmergencyPhone']
        print FName, " ", LName, " ", Username, " ", Email, " ", Password, " ", Gender, " ", EmergencyPhone
 
        if request.method == "POST" and form.validate():
            new_user = User()
            new_user.FName = form.FName.data
            new_user.LName = form.LName.data
            new_user.Username = form.Username.data
            new_user.Email = form.Email.data
            new_user.Password = form.Password.data
            new_user.Gender = form.Gender.data
            new_user.EmergencyPhone = form.EmergencyPhone.data
            db_session.add(new_user)
            db_session.commit()
            flash('Thanks for registering, ' + FName)
        else:
            flash('Error: All the form fields are required. ')
 
    return render_template('newuser.html', form=form)


@app.route('/newroom', methods=['GET', 'POST'])
def new_room():
    form = RoomForm(request.form)
 
    print form.errors
    if request.method == 'POST':
        Name=request.form['Name']
        SensorID=request.form['SensorID']
        print Name, " ", SensorID
 
        if request.method == "POST" and form.validate():
            new_room = Room()
            new_room.Name = form.Name.data
            new_room.SensorID = form.SensorID.data
            db_session.add(new_room)
            db_session.commit()
            flash('Room Added Successfully!')
        else:
            flash(form.errors)
 
    return render_template('newroom.html', form=form)

@app.route('/newappliance', methods=['GET', 'POST'])
def new_appliance():
    form = ApplianceForm(request.form)
    form.Rooms.choices = [(r.RoomID, r.Name) for r in db_session.query(Room)]

    print form.errors
    if request.method == 'POST':
        Type=request.form['Type']
        Name=request.form['Name']
        Rooms=request.form['Rooms']
        print Type, " ", Name, " ", Rooms
 
        if request.method == "POST" and form.validate():
            if form.Type.data == 'Appliance':
                new_appliance = Appliance()
                new_appliance.Name = form.Name.data
                new_appliance.RoomID = form.Rooms.data
                db_session.add(new_appliance)
            else:
                new_door = Door()
                new_door.RoomID = form.Rooms.data
                db_session.add(new_door)

            db_session.commit()
            flash('Added Successfully')
        else:
            flash(form.errors)

    return render_template('newappliance.html', form=form)

@app.route('/admin')
def page():
    rooms=db_session.query(Room)
    appliances=db_session.query(Appliance)
    doors=db_session.query(Door)
    return render_template('admin.html', rooms=rooms, appliances=appliances, doors=doors)


# API for the user's remote login
@app.route('/user_login', methods = ['POST'])
def user_login():
    if not request.json or not 'username' in request.json or not 'password' in request.json:
        abort(400)
    else:
        currentUser = db_session.query(User).filter(User.Username==request.json['username'], User.Password==request.json['password']).first()
        if currentUser:
            print("user logged in successfully..")
            dict_user = currentUser.as_dict()
            return jsonify(dict_user)
        else:
            print("wrong user or pass")
            return jsonify({'error': 'Not found'})



# API for the getting the room name
@app.route('/rooms/<sensorid>')
def getRoom(sensorid):
    currentRoom = db_session.query(Room).filter(Room.SensorID == sensorid).first()
    if currentRoom:
        print("Found Room: "+currentRoom.Name)
        return jsonify({'Room': currentRoom.Name, 'ID': currentRoom.RoomID})
    else:
        print("Room not found")
        return jsonify({'error': 'Not found'})


# API for getting appliances
class appliancesList(Resource):
    def get(self,roomID):
        currentAppliances = db_session.query(Appliance).filter(Appliance.RoomID == roomID)
        return jsonify(Appliances=[e.serialize() for e in currentAppliances])



# API for getting doors
class doorsList(Resource):
    def get(self):
        return jsonify(Doors=[e.serialize() for e in db_session.query(Door)])


api.add_resource(appliancesList, '/appliances/<roomID>')
api.add_resource(doorsList, '/doors')


if __name__ == "__main__":
    app.secret_key = os.urandom(12)
    app.run(host='0.0.0.0')
    app.run()

