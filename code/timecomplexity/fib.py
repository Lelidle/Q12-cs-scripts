import time


def measure():
    result = ""
    for i in range(10000):
        print(i)
        result += timeMeasurementMeans(i)
    with open("res.csv", "w") as f:
        f.write(result)

def timeMeasurementMeans(n):
    sum = 0
    for i in range(10):
        start = time.time_ns()
        fib(n)
        end = time.time_ns()
        sum += (end-start)
    return str(n) + ";" + str(sum/10) + "\n"

def fib(n):
    x = 1
    y = 1
    result = 1
    for i in range(3, n):
        result = x + y
        x = y
        y = result
    return result

if __name__ == "__main__":
    measure()