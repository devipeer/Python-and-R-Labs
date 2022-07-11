class StatePool:
    def __init__(self):
        self.__states = {}
    def GetInst(self, cls):
        if cls not in self.__states:
            self.__states[cls] = cls()
        return self.__states[cls]

class HeroState:
    __statePool = StatePool()
    @classmethod
    def GetInst(cls):
        return HeroState.__statePool.GetInst(cls)

class Standing(HeroState):
    def on_event(self, event):
        if event == "go":
            return Moving.GetInst()
        elif event == "shoot":
            Shooting.previous_state = self
            return Shooting.GetInst()
        else:
            return self

    def __str__(self):
        return "Hero is standing"

class Moving(HeroState):
    def on_event(self, event):
        if event == "stop":
            return Standing.GetInst()
        elif event == "shoot":
            Shooting.previous_state = self
            return Shooting.GetInst()
        else:
            return self
            
    def __str__(self):
        return "Hero is moving"


class Shooting(HeroState):
    previous_state = Standing()
    def on_event(self, event):
        return self.previous_state
            
    def __str__(self):
        return "Hero is shooting"

class Hero:
    def __init__(self):
        self.__current_state = Standing()

    def process_events(self):
        while True:
            print(self.__current_state)
            user_input = input('Select action: ')
            if user_input == 'exit':
                break
            else:
                self.__current_state = self.__current_state.on_event(user_input)

if __name__ == "__main__":
    hero = Hero()
    hero.process_events()