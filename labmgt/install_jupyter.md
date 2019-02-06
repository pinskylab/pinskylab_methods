From Becca Selden:

After our post-lab meeting discussion, I installed jupyter using this method
https://gist.github.com/NickRSearcy/c46771d83a3168481eee

and installing the R kernel as he described with https://irkernel.github.io/installation/

For my Mac running Sierra, I did have to modify the browser thing in the config file to make it open automatically with the "jupyter notebook" command by modifying 
c.NotebookApp.browser = u'chrome'  from the default, and uncommenting that line in the jupyter_notebook_config.py file.
I can help if this is an issue for you too.

If you're using Anaconda instead (which was infinitely simpler)
first install Anaconda , 
then type conda install -c r r-irkernel=0.7.1 in terminal

type "jupyter notebook" in terminal, and the browser will pop up with the option to choose an R notebook in "New" at the top of the page.
