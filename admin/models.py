import os
import sys
from sqlalchemy import Column, ForeignKey, Integer, String, CHAR
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import create_engine
 
Base = declarative_base()
 
class User(Base):
    __tablename__ = 'User'
    # Here we define columns for the table user
    # Notice that each column is also a normal Python instance attribute.
    UserID = Column(Integer, primary_key=True)
    FName = Column(String(250), nullable=False)
    LName = Column(String(250), nullable=True)
    Username = Column(String(250), nullable=False)
    Password = Column(String(250), nullable=False)
    Email = Column(String(250), nullable=False)
    Gender = Column(CHAR, nullable=True)
    EmergencyPhone = Column(Integer, nullable=True)

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}
 
class Admin(Base):
    __tablename__ = 'Admin'
    AdminID = Column(Integer, primary_key=True)
    FName = Column(String(250), nullable=False)
    LName = Column(String(250), nullable=True)
    Username = Column(String(250), nullable=False)
    Password = Column(String(250), nullable=False)

class Room(Base):
    __tablename__ = 'Room'
    RoomID = Column(Integer, primary_key=True)
    Name = Column(String(250), nullable=False)
    SensorID = Column(String(250), nullable=False)

class Appliance(Base):
    __tablename__ = 'Appliance'
    ApplianceID = Column(Integer, primary_key=True)
    Name = Column(String(250), nullable=False)
    State = Column(String(250), default='Off')
    RoomID = Column(Integer, ForeignKey('Room.RoomID'))
    Room = relationship(Room)

class Door(Base):
    __tablename__ = 'Door'
    DoorID = Column(Integer, primary_key=True)
    State = Column(String(250), default='Closed')
    RoomID = Column(Integer, ForeignKey('Room.RoomID'))
    Room = relationship(Room)

class Wheelchair(Base):
    __tablename__ = 'Wheelchair'
    WheelchairID = Column(Integer, primary_key=True)
    UserID = Column(Integer, ForeignKey('User.UserID'))
    User = relationship(User)

#class Address(Base):
    #__tablename__ = 'address'
    # Here we define columns for the table address.
    # Notice that each column is also a normal Python instance attribute.
    #id = Column(Integer, primary_key=True)
    #street_name = Column(String(250))
    #street_number = Column(String(250))
    #post_code = Column(String(250), nullable=False)
    #person_id = Column(Integer, ForeignKey('person.id'))
    #person = relationship(Person)
 
# Create an engine that stores data in the local directory's
# sqlalchemy_example.db file.
engine = create_engine('sqlite:///admin.db')
 
# Create all tables in the engine. This is equivalent to "Create Table"
# statements in raw SQL.
Base.metadata.create_all(engine)