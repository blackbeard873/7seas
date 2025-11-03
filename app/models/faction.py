from sqlalchemy import Column, Integer, String
from app.database import Base

class Faction(Base):
    __tablename__ = "factions"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
