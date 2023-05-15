"""Optional assignment: Plotting the relation between EMG and GRF signal; Finding the offset time"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import signal
from plot_emg import remove_offset, rectify, lpf

def main():
    # Setup variables
    t0 =  0.0                        # time of the beginning of the plot [s] (this time is included)
    t1 = 90.0                        # time of the end of the plot [s] (this time is NOT included!)
    filename_emg = "emg1.csv"         # filename of EMG data
    filename_grf = "forceplate1.csv"  # filename of GRF data
    figplot_name_before = "../results/linear_plot_before.png"
    figplot_name_after = "../results/linear_plot_after.png"
    figscatter_name_before = "../results/scatter_plot_before.png"
    figscatter_name_after = "../results/scatter_plot_after.png"
    idx_emg = 2  # EMG signal to be shown (0: EMG #1, 1: EMG #2, ..., 5: EMG #6)
    idx_grf = 2  # GRF signal to be shown (0: Fx, 1: Fy, 2: Fz, 3: Mx, 4: My, 5: Mz)
    t_offset = 0  # Initializing the offset time value
    
    # Load an EMG data.
    df_emg = pd.read_csv(filename_emg, usecols=[0, 1, 21, 41, 61, 81, 101])
    df_grf = pd.read_csv(filename_grf, header=31, usecols=[1, 3, 4, 5, 6, 7, 8])

    # Remove not-available values in the end of the time column
    df_emg = df_emg.dropna()

    # Obtaining the emg and grf data
    data_emg = obtaining_emg_data(df_emg, idx_emg)
    data_grf = obtaining_grf_data(df_grf, idx_grf)

    # Synchronize time of EMG and GRF signal
    data_grf['Time'] += t_offset

    # Plot the data
    linear_plot(data_emg, data_grf, t0, t1, 't_offset = 0', figplot_name_before)

    # Plotting the relation between EMG and GRF signal
    scatter_plot(data_emg, data_grf, 't_offset = 0', figscatter_name_before, direction='nearest')

    # Obtaining the offset
    t_offset = count_offset(data_emg, data_grf)

    # Updating the time
    data_grf['Time'] += t_offset

    # Plotting the relation between EMG and GRF signal with new offset time
    linear_plot(data_emg, data_grf, t0, t1, 'new t_offset', figplot_name_after)

    # Plotting the relation between EMG and GRF signal with new offset time
    scatter_plot(data_emg, data_grf, 'new t_offset',figscatter_name_after ,direction='nearest')

def obtaining_emg_data(df_emg, idx_emg):
    """Function to obtain the desired EMG column data"""
    labels_emg = ["EMG #1", "EMG #2", "EMG #3", "EMG #4", "EMG #6", "EMG #7"] # EMG column labels
    data_emg = pd.DataFrame() # Initiating dataframe
    data_emg['Time'] = df_emg.iloc[:, 0] # Acquiring the times column
    df_emg = processing_data(df_emg.iloc[:, idx_emg + 1], data_emg['Time']) * 1000 # Processing the desired EMG column
    data_emg[labels_emg[idx_emg]] = df_emg # Acquiring the processed desired column
    return data_emg

def obtaining_grf_data(df_grf, idx_grf):
    """Function to obtain the desired GRF column data"""
    labels_grf = ["Fx", "Fy", "Fz", "Mx", "My", "Mz"] # GRF column labels
    data_grf = pd.DataFrame() # Initiating dataframe
    data_grf['Time'] = df_grf.iloc[:, 0] # Acquiring the times column
    data_grf[labels_grf[idx_grf]] = df_grf.iloc[:, idx_grf + 1] # Acquiring the processed desired column
    return data_grf

def processing_data(data, times_data):
    """Processing function for the EMG signal"""
    data = remove_offset(data)         # 1) Remove offset values
    data = rectify(data)               # 2) Rectify the data
    data = lpf(data, times_data, fc=2)  # 3.1) Apply low-pass filter
    return data

def linear_plot(data_emg, data_grf, t0, t1, title, figname):
    """Linear plot of EMG and GRF with respect to time"""
    fig = plt.figure(figsize=(12, 8))
    ax1 = fig.add_subplot(1, 1, 1)
    ax2 = ax1.twinx()
    ax1.plot(data_emg.iloc[:, 0], data_emg.iloc[:, 1], color="C0", label=data_emg.columns[1])
    ax2.plot(data_grf.iloc[:, 0], data_grf.iloc[:, 1], color="C1", label=data_grf.columns[1] + " 1")
    ax1.set_xlabel("Time [s]")
    ax1.set_xlim((t0, t1))
    ax1.set_ylabel(data_emg.columns[1] + " [mV]")
    ax2.set_ylabel(data_grf.columns[1] + " [N, Nm]")
    ax1.set_title(title)
    fig.legend()
    fig.tight_layout()

    # Save the figure
    plt.savefig(figname)

    # Show the figure
    plt.show()

def scatter_plot(data_emg, data_grf, title, figname, direction='nearest'):
    """Scatter plot between EMG and GRF signal"""
    combine = pd.merge_asof(data_grf, data_emg, on='Time', direction=direction) # Merging GRF and EMG data (left join)
    fig, ax = plt.subplots()
    fig.set_size_inches(12, 8)
    ax.scatter(combine.iloc[:, 2], combine.iloc[:, 1]) 
    ax.set_xlabel(combine.columns[2] + " [mV]")
    ax.set_ylabel(combine.columns[1] + " [N, Nm]")
    ax.set_title(title)
    plt.savefig(figname)
    plt.show()

def count_offset(data_emg, data_grf):
    max_emg = data_emg.iloc[data_emg.iloc[:, 1].argmax(), :] # Obtaining the maximum value of EMG data
    max_grf = data_grf.iloc[data_grf.iloc[:, 1].argmax(), :] # Obtaining the maximum value of GRF data
    print(f'maximum value of {data_emg.columns[1]}: \n{max_emg}')
    print(f'maximum value of {data_grf.columns[1]}: \n{max_grf}')

    # Calculating the offset
    t_offset = max_emg['Time'] - max_grf['Time'] # Substracting emg peak's time with grf peak's time
    print(f'the offset time: {t_offset}')
    return t_offset

if __name__ == "__main__":
    main()