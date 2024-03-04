import sys
def toDoList():
    with open('to-doList.txt','r') as textFile:
        todoList = textFile.read().splitlines()
    listOfOptions = [
        '1. view tasks',
        '2. add a task',
        '3. delete a task',
        '4. save changes',
        '5. quit'
    ]
    
    print(f'Here is your list of options {listOfOptions}')
    userOption = int(input("Enter what you want to do with the list: 1/2/3/4/5? "))
    print(listOfOptions[userOption-1])
    if userOption == 5:
            sys.exit()
    elif userOption == 1: 
            if len(todoList) == 0:
                print('There is nothing to do!')
    elif userOption == 2:
            newTask = str(input('What task do you want to add? '))
            todoList.append(newTask)
    elif userOption == 3:
            deleteTask = int(input('What task do you want to delete. Enter number '))
            todoList.pop(deleteTask-1)
    elif userOption == 4:
            with open('to-doList.txt','w') as textFile:
                textFile.write(todoList)
    print(todoList)
toDoList()