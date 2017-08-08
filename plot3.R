# In order to make loading of the data manageble I've filtered the source file. 
# Using the texteditor (BBEdit) everything except data for 2007-02-01 and 
# 2007-02-02 was deleted. Note that only the header and the lines starting with 
# "1/2/2007" and "2/2/2007" were kept. The relevant data is stored in "datafile.txt"
# and is only about 180 KB in size (2880 lines excluding the header). This means
# it can be easily uploaded to GitHub and used to test the functionality of the
# code —- including reading of the data into R.


# First we need to set the proper working directory, with something like:
# setwd("~/Documents/R/Exploratory Data Analyses/Course Project 1")


# Importing the data from the file into R:
dataframe <- read.table("datafile.txt", header = T, sep = ";", stringsAsFactors = F, na.strings = "?")
# We filtered out the possible "?" characters by replacing them with NA's (they 
# weren't present in this dataset, but could be in another subset of the data). 
# Also set the stringsAsFactors to FALSE, because otherwise the "Date" and
# "Time" variables will become factors (that will need to be converted to
# strings later on).


# Inspecting the result:
# str(dataframe)
# 'data.frame':	2880 obs. of  9 variables: <-- That looks exactly right!


# The variables "Date" and "Time" have been imported as character classes. We
# don't want that, so we convert those to the proper date format:

# We must use strptime() to convert "Date" and "Time" to a POSIXlt class
# (POSIXlt, because we need to aggregate by days for the plots):

# First use paste() to combine "Date" and "Time" into one variable:
dataframe$Date <- paste(dataframe$Date, dataframe$Time)

# Remove obsolete column "Time":
dataframe$Time <- NULL

# Now convert the repurposed "Date" variable to POSIXlt:
dataframe$Date <- strptime(dataframe$Date, "%d/%m/%Y %H:%M:%S")

# Now the dataframe is fully prepared. Let's create some plots!


# Plot #3:
png(filename = "plot3.png", width = 480, height = 480)
plot(dataframe$Sub_metering_1, type = 'l', ylab = "Energy sub metering", xlab = '', xaxt = 'n')
lines(dataframe$Sub_metering_2, type = 'l', col = 'red')
lines(dataframe$Sub_metering_3, type = 'l', col = 'blue')
legend("topright", c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), lwd = 1, col = c('black', 'red', 'blue'))
axis(side = 1, labels = c("Thu", "Fri", "Sat"), at = c(1, 1440, 2880))
dev.off()
