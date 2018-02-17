from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField, SelectField

class UserForm(Form):
    FName = StringField('Fname:', validators=[validators.required()])
    LName = StringField('Lname:', validators=[validators.required()])
    Username = StringField('Username:', validators=[validators.required()])
    Email = StringField('Email:', validators=[validators.required(), validators.Length(min=6, max=35)])
    Password = StringField('Password:', validators=[validators.required(), validators.Length(min=3, max=35)])
    Gender = StringField('Gender:', validators=[validators.required()])
    EmergencyPhone = StringField('EmergencyPhone:', validators=[validators.required()])

class RoomForm(Form):
    Name = StringField('Name', validators=[validators.required()])
    SensorID = StringField('SensorID', validators=[validators.required()])

class ApplianceForm(Form):
    Type = StringField('Type', validators=[validators.required()])          
    Name = StringField('Name', validators=[validators.required()])
    Rooms = SelectField('Rooms', validators=[validators.required()], coerce=int)
