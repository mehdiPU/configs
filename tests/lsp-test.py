
from testClass import *
import math

class Whatever:
    pass

class AMeaninglessClass:
    def __init__(self, value: int, testObject: TestClass):
        self.value = value
        self.testAttribute = testObject

    def do_some_nonsense(self):
        priviousValue = self.value
        for i in range(self.value):
            self.value += i

    def getTestAttribute(self):
        return self.testAttribute

    def __str__(self):
        return str(self.value) + self.testAttribute.getNameString()

def main():
    testObject = TestClass("Mehdi")
    meaninglessObject = AMeaninglessClass(6, testObject)
    print(meaninglessObject)
    name = testObject.getNameString()
    for i in range(16):
        meaninglessObject.do_some_nonsense()
        print(meaninglessObject)
        print(testObject)
        testObject = TestClass(testObject.getNameString() + str(i))
        

main()
