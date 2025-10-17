from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class Player(Base):
    __tablename__ = 'players'
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
    faction_id = Column(Integer, ForeignKey('factions.id'))
    faction = relationship('Faction', back_populates='players')
