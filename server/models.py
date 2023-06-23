from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import MetaData
from sqlalchemy.orm import validates
from sqlalchemy.ext.associationproxy import association_proxy

convention = {
  "ix": "ix_%(column_0_label)s",
  "uq": "uq_%(table_name)s_%(column_0_name)s",
  "ck": "ck_%(table_name)s_%(constraint_name)s",
  "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
  "pk": "pk_%(table_name)s"
}


metadata = MetaData(naming_convention=convention)

db = SQLAlchemy(metadata=metadata)

class Data(db.Model):
    __tablename__ = "data"

    id = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.String, server_default="WOW", nullable=False)

    def __repr__(self):
        return f'<Data {self.id}, "{self.text}">'
    
    def to_dict(self):
        return {
            "id": self.id,
            "text": self.text
        }