from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.player import Player

class Faction(Base):
    __tablename__ = 'factions'
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True)
    players = relationship('Player', back_populates='faction')
