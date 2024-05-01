valid_amount = []
def _amount_():
    try:
        flag = True
        amount = input()
        for a in amount:
            if a not in str(list(range(0,10))):
                flag = False
                raise TypeError('Amount must be numerical')
        if flag:
            valid_amount.append(float(amount))       
    except TypeError:
        _amount_()

class Account:
    def __init__(self, account_id,balance, interest = 0):
        
        '''checking if account id is string'''

        if not isinstance(account_id,str):
            raise TypeError('Account ID must be string')    
        for id in account_id:
            if id not in str(list(range(0,10))):
                raise ValueError('Account ID must be within 0-9')
        for num in balance:
            if num not in str(list(range(0,10))) and num != '.':
                raise ValueError('Balance must be number')
        
        '''assign the attributes'''

        self.account_id = account_id
        self.balance = float(balance)
        self.interest = interest

    '''print message'''

    def __str__(self):
        return f'{self.account_id},{round(self.balance,2)},{self.interest}'

    def _withdraw_(self):

        '''prompt the user to choose amount to withdraw'''

        print('Amount: ',flush = True)
        _amount_()
        deducted_amount = valid_amount[-1]

        '''prevent user from withdrawing more than their balance '''

        self.balance -=  deducted_amount
        if self.balance < 0:
            print('Cannot proceed your withdrawal')
            self.balance += deducted_amount
    
    def _deposit_(self):

        print('Amount: ',flush = True)
        _amount_()
        increased_amount = valid_amount[-1]
        self.balance += increased_amount 


class Checking(Account):
    def __init__(self,account_id,balance,interest):
        super().__init__(account_id,balance,interest)
        self.interest = 0
    
    def __str__(self):
        return f'{self.account_id}  {round(float(self.balance),2)}'

class Savings(Account):
    def __init__(self,account_id,balance,interest):
        super().__init__(account_id,balance,interest)
        self.interest = 1
    
    def __str__(self):
        return f'{self.account_id}  {round(float(self.balance),2)}'

class Credit(Account):

    def __init__(self, account_id, balance, interest, credit_limit):
        super().__init__(account_id, balance, interest)
        self.interest = 30
        self.limit = float(credit_limit)
        
    def __str__(self):
        return f'{self.account_id}  {round(float(self.balance),2)}  {self.interest}  {self.limit}'
    
    def __credit_card_charge__(self):

        '''promt user to choose amount'''

        print('Amount: ', flush = True)
        _amount_()
        increased_amount = valid_amount[-1]

        '''prevent user to charge more than their limit'''
        
        self.balance += increased_amount
        if increased_amount > self.limit:
            print('You have passed your credit limit')
            self.balance -= increased_amount
    
    def _credit_card_payment_(self):

        account_name,account_type = valid_name[-1]
        print('Amount: ', flush = True)
        _amount_()
        deducted_amount = valid_amount[-1]

        if account_type in ['savings','Savings']:
            customer_collection[account_name].savings.balance -= deducted_amount
        elif account_type in ['checking','Checking']:
            customer_collection[account_name].checking.balance -= deducted_amount
        self.balance -= deducted_amount

        '''incur invalid transaction'''

        if self.balance < 0 or customer_collection[account_name].savings.balance < 0  or customer_collection[account_name].checking.balance < 0 :
            print('Cannot proceed your payment')
            self.balance += deducted_amount
            customer_collection[account_name].savings.balance += deducted_amount
            customer_collection[account_name].checking.balance += deducted_amount

                

class Customer:
    def __init__(self,username,checking,savings,credit):
        self.username = username
        self.savings = savings
        self.checking = checking
        self.credit = credit
    
    def __str__(self):
        return f'{self.username}  {self.checking}  {self.savings}  {self.credit}'

import csv
customer_collection = {}
def reading_info():
    with open('accounts.csv') as csvFile:
        account_info = csv.DictReader(csvFile)
        for row in account_info:
            checking = Checking(row['checking_id'],row['checking_balance'],34)
            savings = Savings(row['savings_id'],row['savings_balance'],34)
            credits = Credit(row['credit_id'],row['credit_balance'],57,row['credit_limit'])
            username = Customer(row['username'],checking,savings,credits)
            global customer_collection
            customer_collection[row['username']] = username


def exit():
    customers = []
    for value in customer_collection.values():
        customers.append({'username':value.username,
                         'checking_id': value.checking.account_id,'checking_balance':value.checking.balance,
                         'savings_id':value.savings.account_id,'savings_balance':value.savings.balance,
                        'credit_id':value.credit.account_id,'credit_balance':value.credit.balance,'credit_limit':value.credit.limit})
    with open('accounts_modified.csv','w',newline='') as csvFile:
        updated_accounts = csv.DictWriter(
            csvFile,
            fieldnames= ['username','checking_id','checking_balance','savings_id','savings_balance','credit_id','credit_balance','credit_limit']
        )
        updated_accounts.writeheader()
        updated_accounts.writerows(customers)

valid_name = []
def name_lookup():

    '''prompt user to put in only valid customer name and account type'''

    try:
        account_name = input('Customer name:')
        account_type = input('Checking or Savings ')
        if account_name not in customer_collection.keys() or account_type not in ['Savings','savings','checking','Checking']:
            raise ValueError('invalid name/account type')
        else:
            valid_name.append((account_name,account_type))
    except ValueError:
        name_lookup()

def interface():

    reading_info()
    print(' 1. View Customer\n',
                '2. Deposit\n',
                '3. Withdraw\n',
                '4. Credit Card Charge\n',
                '5. Credit Card Payment\n',
                '6. Exit\n')
    user_choice = ''
    
    while user_choice != '6':
        user_choice = input('Enter your choice (1/2/3/4/5/6) ')
        '''display options and prompt user to choose'''
        
        if user_choice == '1':
            for customer in customer_collection.values():
                print(customer) 
        
        elif user_choice == '2':
            name_lookup()
            account_name,account_type = valid_name[-1]
            if account_type in ['Checking','checking']:
                customer_collection[account_name].checking._deposit_()
            elif account_type in ['Savings','savings']:
                customer_collection[account_name].savings._deposit_()

            '''withdraw action'''

        elif user_choice == '3':

            '''prompt the user to choose customer name and account type'''
            '''avoid typo/invalid name/account'''
                    
            name_lookup()
            account_name,account_type = valid_name[-1]

            
            '''proceed withdrawing by calling withdraw method for corresponding account type'''

            if account_type in ['Checking','checking']:
                customer_collection[account_name].checking._withdraw_()
            elif account_type in ['Savings','savings']:
                customer_collection[account_name].savings._withdraw_()

            '''display customer account after withdrawing'''
            
            print(customer_collection[account_name])
            
            '''creditcard charge method'''
            
        elif user_choice == '4':
            
            '''prompt user to choose customer name and proceed the method'''
            name_lookup()
            account_name,account_type = valid_name[-1]
            
            '''perform credit card charge action'''

            customer_collection[account_name].credit.__credit_card_charge__()

            print(customer_collection[account_name])
        
        elif user_choice == '5':

            name_lookup()
            account_name,account_type = valid_name[-1]
            
            '''perform credit card payment action'''

            customer_collection[account_name].credit._credit_card_payment_()

            print(customer_collection[account_name])
        
        elif user_choice == '6':
            exit()
        print(' 1. View Customer\n',
                '2. Deposit\n',
                '3. Withdraw\n',
                '4. Credit Card Charge\n',
                '5. Credit Card Payment\n',
                '6. Exit\n')
        
interface()




