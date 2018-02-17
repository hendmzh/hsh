from flask_table import Table, Col

class Results(Table):
    id = Col('Id', show=False)
    room = Col('Room')
    name = Col('Name')
    state = Col('State')
