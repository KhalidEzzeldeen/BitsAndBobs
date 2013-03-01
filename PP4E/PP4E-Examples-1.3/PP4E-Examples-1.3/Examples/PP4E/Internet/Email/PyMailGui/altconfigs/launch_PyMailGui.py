# to run without PYTHONPATH setup (e.g., desktop)
import os                                         # Launcher.py is overkill
os.environ['PYTHONPATH'] = r'..\..\..\..\..'      # hmm; generalize me
os.system('PyMailGui.py')                         # inherits path env var
