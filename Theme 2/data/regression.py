import numpy as np
import matplotlib.pyplot as plt

class LinearRegression():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def delta(self):
        self.delta = self.x.shape[0] * np.sum(self.x ** 2) - (np.sum(self.x)) ** 2
        return self.delta
    
    def a_best(self):
        numerator =self.x.shape[0] * np.sum(self.x * self.y) - np.sum(self.x) * np.sum(self.y)
        self.a_best = numerator / self.delta
        return self.a_best

    def b_best(self):
        numerator = np.sum(self.x ** 2) * np.sum(self.y) - np.sum(self.x) * np.sum(self.x * self.y)
        self.b_best = numerator / self.delta
        return self.b_best

    def sigma_y(self):
        numerator = np.sum((self.y - (self.a_best * self.x + self.b_best)) ** 2)
        denominator = self.x.shape[0] - 2
        self.sigma_y = np.sqrt(numerator / denominator)
        return self.sigma_y
    
    def sigma_a(self):
        self.sigma_a = self.sigma_y * np.sqrt(self.x.shape[0] / self.delta)
        return self.sigma_a

    def sigma_b(self):
        self.sigma_b = self.sigma_y * np.sqrt(np.sum(self.x ** 2) / self.delta)
        return self.sigma_b

    