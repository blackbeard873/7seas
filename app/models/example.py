from sqlalchemy import Column, Integer, String
from .database import engine
from sqlalchemy.orm import declarative_base

Base = declarative_base()

class ExampleModel(Base):
**tablename** = 'examples'
id = Column(Integer, primary_key=True, index=True)
name = Column(String, index=True)
