# Guides / Resources
[SW Carpentry tutorial](https://swcarpentry.github.io/python-novice-inflammation/)

# Setup

Activate anaconda environment first:
```sh
conda activate
python
```

Libraries:
```py
from math import *
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import glob
import sys      # connects Python to system it is running on
```

Access data:
```py
# load 1 data set:
data = np.loadtxt(fname='inflammation-01.csv', delimiter=',')

# use multiple data sets to do something:
filenames = sorted(glob.glob('inflammation*.csv'))  # wildcards: * for char(s), ? for 1 char
for f in filenames:
    print(f)    # or do other things e.g. create plots

# Example: statistics normalized per file
filenames = glob.glob('inflammation*.csv')
composite_data = np.zeros((60,40))   # array filled with zeros
for f in filenames:                  # fill array with file contents
    data = np.loadtxt(fname = f, delimiter=',')
    composite_data += data          # like `composite_data = composite_data + data`

composite_data /= len(filenames)    
fig = plt.figure(figsize=(10.0, 3.0))
axes1 = fig.add_subplot(1, 3, 1)
axes2 = fig.add_subplot(1, 3, 2)
axes3 = fig.add_subplot(1, 3, 3)
axes1.set_ylabel('average')
axes1.plot(np.mean(composite_data, axis=0))
axes2.set_ylabel('max')
axes2.plot(np.max(composite_data, axis=0))
axes3.set_ylabel('min')
axes3.plot(np.min(composite_data, axis=0))
fig.tight_layout()
plt.show()
```

Glob and read CSVs with Pandas:

```py
mydata = pd.DataFrame()
path = "mat/*.csv"
for fname in glob.glob(path):
    df = pd.read_csv(fname)
    mydata = mydata.append(df, ignore_index=True)
mydata
```

# Data Exploration

Data preview:
```py
print(data)
```

Data attributes:
```py
print(type(data))
print(data.dtype)
print(data.shape)
```

Data values:
```py
print('first value in data: ', data[0,0])
print('some rows of data: ', data[0:4])
print('unbounded rows of data: ', data[5:])
print('a segment of data: ', data[0:4, 0:10])
```

# Arrays

Multiply by a factor:
```py
print(data * 2.0)
```

Multiply by an array:
```py
print(data*data)
```

Stats for a row:
```py
print('max for patient 0:', np.max(data[0,:]))
```

Stat of each row / column:
```py
print(np.mean(data,axis=0)) # outputs vector of means of rows
print(np.mean(data,axis=1)) # outputs vector of means of columns
```

# Lists

Create and access list:
```py
odds = [1,3,5,7]
print('odds are:', odds)
print('first element:', odds[0])
print('last element:', odds[-1])
```

Modify list:
```py
names = ['Curie', 'Darwing', 'Turing']
names[1] = 'Darwin'         # replace element
names.append('Einstein')    # add element 
del names[2]                # remove element
names.reverse()             # reverse element order
```

Variables based on lists:
```py
grades = ['a','b','c']
alt_grades = grades       # assign to variable
grades[0] = 'f'
print(grades)             # -> ['f', 'b', 'c']
print(alt_grades)         # -> ['f', 'b', 'c'] (dependency impact)

grades = ['a','b','c']
alt_grades = list(grades) # assign to copy
grades[0] = 'f'
print(grades)             # -> ['f', 'b', 'c']
print(alt_grades)         # -> ['a', 'b', 'c'] (no dependency impact)
```

Nested lists:
```py
x = [['pepper', 'zucchini', 'onion'],
     ['cabbage', 'lettuce', 'garlic'],
     ['apple', 'pear', 'banana']]
print([x[0]])   # -> [['pepper', 'zucchini', 'onion']]
print(x[0])     # -> ['pepper', 'zucchini', 'onion']
print(x[0][0])  # -> pepper
```

Non-continuous slices:
```py
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
evens = numbers[1::2]    # 3rd argument is step size
print(evens)            # -> [2, 4, 6, 8, 10, 12]

beatles = "In an octopus's garden in the shade"
every_other = beatles[::2] # every other char
print(every_other)         # -> I notpssgre ntesae
```

List multiplication:
```py
counts = [2, 4, 6, 8, 10]
print(counts*2)     # -> [2, 4, 6, 8, 10, 2, 4, 6, 8, 10]
```

List comprehension:

```py
mynames=['Tom', 'Dick', 'Harry']
['Hello '+ person for person in mynames]



a =[1,2,3]
b =[3,4,5]
[(c,d) for c in a for d in b if c % 2 == 0 and d % 2 == 0]
```

# NumPy Math

Summary statistics:
```py
np.mean(data)
mean, maxval, minval, stdval = np.mean(data), np.max(data), np.min(data), np.std(data)  # multiple assignment on 1 line
```

Window functions:
```py
# Change along array:
npdiff = np.array([ 0,  2,  5,  9, 14])
np.diff(npdiff) # -> [2, 3, 4, 5]

# Change along an axis of an array:
np.diff(data, axis=1)   # running along days (columns) for each patient (rows)
```

# Plots / Visualization

Array heat map:
```py
image = plt.imshow(data)
plt.show()
```

Line graph:
```py
ave_inflammation = np.mean(data, axis=0)
ave_plot = plt.plot(ave_inflammation)
plt.show()
```

Group subplots (like facets):
```py
fig = plt.figure(figsize=(10.0, 3.0)) # visual size of each plot
axes1 = fig.add_subplot(1, 3, 1)    # total rows, total columns, which variable for this axis (left-to-right, top-to-bottom)
axes2 = fig.add_subplot(1, 3, 2)
axes3 = fig.add_subplot(1, 3, 3)
axes1.set_ylabel('average')
axes1.plot(np.mean(data, axis=0))
axes2.set_ylabel('max')
axes2.plot(np.max(data, axis=0))
axes3.set_ylabel('min')
axes3.plot(np.min(data, axis=0))
fig.tight_layout()
plt.show()
```

Plot from multiple files with Glob:
```py

# plot for each file:
filenames = sorted(glob.glob('inflammation*.csv'))[0:4]
for f in filenames:
    print(f)
    data = np.loadtxt(fname=f, delimiter=',')
    fig = plt.figure(figsize=(10.0, 3.0))
    axes1 = fig.add_subplot(1, 3, 1)
    axes2 = fig.add_subplot(1, 3, 2)
    axes3 = fig.add_subplot(1, 3, 3)
    axes1.set_ylabel('average')
    axes1.plot(np.mean(data, axis=0))
    axes2.set_ylabel('max')
    axes2.plot(np.max(data, axis=0))
    axes3.set_ylabel('min')
    axes3.plot(np.min(data, axis=0))
    fig.tight_layout()
    plt.show()

# plot based on a comparison between two files:
filenames = sorted(glob.glob('inflammation*.csv'))
data0 = np.loadtxt(fname=filenames[0], delimiter=',')
data1 = np.loadtxt(fname=filenames[2], delimiter=',')
fig = plt.figure(figsize=(10.0, 3.0))
plt.ylabel('Difference in minimums')
plt.plot(np.min(data0, axis=0) - np.min(data1, axis=0))
fig.tight_layout()
plt.show()
```

# String Manipulation

Substring based on start-end:
```py
element = 'oxygen'
print('first 3:', element[0:3]) # -> oxy. end of range is exclusive!
```
Select the last letter(s):
```py
print(element[-1])      # -> n
print(element[-3:])     # -> gen
```

String length:
```py
len('word')
```

Starts with match:
```py
word = 'example'
word.startswith('exa')  # -> true
```

Common special characters:
    \n   Newline (linefeed)
    \t   horizontal tab
    \    a single backslash
    \"   a double-quote
    \'   a single-quote (apostrophe)
    \e   an ASCII escape character

Special prints:

```py
s=r"string with \n newline"
print(s)                              # normal printing
print(r"string with \n newline")      # raw: specials as literals
print(repr(s))                        # printable representation of object
```

Cases:

```py
s='some texT'
s.title()      # Some Text
s.capitalize() # Some text
s.swapcase()   # SOME TEXt
s.upper()      # SOME TEXT
```


# Loops

Print each letter:
```py
word = 'oxygen'
for char in word:   # "for variable in collection"
    print(char)     # "do thing using each variable"
```

Count each letter:
```py
length = 0
for vowel in 'aeiou':
    length = length + 1

print(length,' vowels')             # line break required after loop
# equivalent to: print(len('aeiou'),' vowels')
print(vowel,' is the last vowel')   # loop variable exists outside loop
```

Range and increments:
```py
for i in range(60,101,5):  #values 60-100 in steps of 5
    print(i)
```

Product of factors:
```py
factors = [7,8,9,10]
result = 1
for i in factors:
    result = result * i

print(result)
```

Reverse string:
```py
word = 'Newton'
drow = ''
for char in word:
    drow = char + drow

print(drow)
```

Calculate polynomial with enumerate:
```py
x = 5
cc = [2,4,3]    # coefficients
y = 0           # initialize to zero every time
for i, c in enumerate(cc):
    y = y + c * x**i

print(y)
# equivalent to 97 = 2 + 4*(5) + 3*(5*5)
```

# Logic

If elif else:
```py
num = -3
if num > 0:
    print(num, 'is positive')
elif num == 0:
    print(num, 'is zero')
else:       # else is optional
    print(num, 'is negative')
```

Values from a list satisfying a condition:
```py
# values within +/- 10% of a target:
a = [50,90,95,100,105,110,115]
b = 100
for i in a:
    if i >= 0.9*b and i <= 1.1*b:
        print(i)
```

Sort list into buckets:
```py
files = ['inflammation-01.csv','myscript.py','inflammation-02.csv','small-01.csv','small-02.csv']
large_files, small_files, other_files = [], [], []
for f in files:
    if f.startswith('inflammation'):
        large_files.append(f)
    elif f.startswith('small'):
        small_files.append(f)
    else:
        other_files.append(f)
```

Count vowels:
```py
word = 'California'
vowels = 'aeiouAEIOU'
count = 0
for i in word:
    if i in vowels:
        count += 1

print(count)
```

# Functions

Define, document, and nest functions:
```py
def fahr_to_celsius(temp_f):
    '''docstring here
    multiple lines use triple quote'''
    return ((temp_f - 32) * (5/9))

def celsius_to_kelvin(temp_c):
    return temp_c + 273.15

def fahr_to_kelvin(temp_f):
    'docstring is returned by help function'
    return (celsius_to_kelvin(fahr_to_celsius(temp_f)))

help(fahr_to_kelvin)

print(fahr_to_kelvin(32))
```

Function defaults:
```py
def offset_mean(data, target_mean_value=0.0):
    '''Return a new array containing the original data with its mean offset to match the
       desired value (0 by default)'''
    return (data - np.mean(data)) + target_mean_value

offset_mean([1, 2, 3])  # equivalent to offset_mean([1, 2, 3],0)
```

Sample standard deviation:
```py
def std_dev(sample):
    sample_sum = 0
    for value in sample:
        sample_sum += value

    sample_mean = sample_sum / len(sample)

    sum_squared_devs = 0
    for value in sample:
        sum_squared_devs += (value - sample_mean) * (value - sample_mean)

    return np.sqrt(sum_squared_devs / (len(sample) - 1))
```

Rescale array:
```py
def rescale(input_array, lower=0, upper=1):
    'scale array values to range (0-1 default)'
    low = np.min(input_array)
    high = np.max(input_array)
    intermediate_array = (input_array - low) / (high - low)
    output_array = intermediate_array * (upper - lower) + lower
    return output_array

rescale([11,12,13])        # -> array([0. , 0.5, 1. ])
rescale([11,12,13],0,10)   # -> array([ 0.,  5., 10.])
```

# Defensive Programming 

Assertions:
```py
numbers = [1, 3, -4]
total = 0
for n in numbers:
    assert n > 0, 'Data should only contain positive values'
    total += n

print('total is:', total)
```

Test-driven development:
```py
def range_overlap(ranges):
    '''Return common overlap among a set of [left, right] ranges.'''
    max_left = 0.0      # bad. Try to always initialize from data
    min_right = 1.0     # fix with: `max_left, min_right = ranges[0]`
    for (left, right) in ranges:
        max_left = max(max_left, left)
        min_right = min(min_right, right)
    return (max_left, min_right)

# write these tests first, then the rest of the program:
def test_range_overlap():
    assert range_overlap([ (0.0, 1.0), (5.0, 6.0) ]) == None
    assert range_overlap([ (0.0, 1.0), (1.0, 2.0) ]) == None
    assert range_overlap([ (0.0, 1.0) ]) == (0.0, 1.0)
    assert range_overlap([ (2.0, 3.0), (2.0, 4.0) ]) == (2.0, 3.0)
    assert range_overlap([ (0.0, 1.0), (0.0, 2.0), (-1.0, 1.0) ]) == (0.0, 1.0)
    assert range_overlap([]) == None

test_range_overlap()
```

Try-Except:

```py
(x,y) = (5,0)
try:
    z = x/y
except Exception as e:      # any exception
    print(str(e))
    print(repr(e))



(x,y) = (5,0)
try:
    z = x/y
except ZeroDivisionError:  # specific error
    print("divide by zero")



```

# Shell

Run a script from another folder with --flags:
```sh
# our data is in the \data\ directory:
cd C:\Users\cbett\Dropbox\Everything\Journal\Academics\Online-Classes\SW-Carpentry\Python-Inflammation\swc-python\data\

# calculate mean of a file using the readings_04.py script in the \code\ directory:
python ../code/readings_04.py --mean inflammation-01.csv
```

Print the contents of a file:
```sh
cat ../code/readings_04.py
```

IDEA: review [Argparse tutorial](http://docs.python.org/3/howto/argparse.html)

