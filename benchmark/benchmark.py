import os
import sys
import time
# Add cpt to python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from cpt import Cpt  # pylint: disable=wrong-import-position

with open("data/FIFA.dat") as file:
    data = list(map(lambda l: [int(x) for x in l.rstrip().split() if int(x) >= 0], file.readlines()))

cpt = Cpt()

cpt.fit(data)

prediction_data = list(map(lambda x: x[-10:], data))

cpt.MBR = 10
cpt.noise_ratio = 0.2

time1 = time.time()
cpt.predict(prediction_data, True)
time2 = time.time()
print(f"time ellapsed {(time2-time1)*1000} ms")
