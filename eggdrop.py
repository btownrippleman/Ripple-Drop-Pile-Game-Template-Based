#question posed to me by haroon from hack reactor of eggs, this shows each floor you'd hit if you dropped an egg to the 14th floor and then dropped it another 13, then 12 and so forth
print("hello")
floor = 0
for i in reversed(range(1,15)):
        floor = floor +i
        print(str(floor)+" "+str(i))

	
