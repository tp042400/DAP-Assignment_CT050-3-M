################################################################
# Remove additonal notes (title, description and footer notes) #
################################################################
import pandas as pd
df = pd.read_excel(r'C:\Prelim Semiannual Report to FIOU - Dec 14 2015\Table 4\Table_4_January_to_June_2015.xls', 
                   sheetname='15table4', 
                   header=4,
                   skipfooter=11)


#####################################################
# Fill in the missing values caused by merged cells #
#####################################################
def fill_in_na(df, arr):
    for iarr in arr:                        # Loop columns
        check = ~df[iarr].isnull()          # Identify row index that is NOT missing
        for i in range(len(df[iarr])):      # Loop every single row
            if check[i]: 
                val = df[iarr][i]           # Store the value in that row if it is NOT a missing value / 'NaN' 
            else:
                df[iarr][i] = val           # Fill up with the stored value if it is a missing value / 'NaN'
    return df                               # Return the data frame

df = fill_in_na(df, ['State', 'City'])      # Execute the function on columns 'State' and 'City'


#############################################################################################
# Remove the data remark in superscript form exist in headers and  columns 'State' & 'City' #
#############################################################################################

## i) Clean headers
def clean_colnames(df):
    colnames = []                                                         # Initialize an array
    for col in df.columns.tolist():                                       # Loop every header
        try:
            col = re.compile(r'(\D+)\d+$').findall(col)[0]                # Finding the header with digit(s) as last character
        except AttributeError:
            pass                                                          # Skip if no digit(s) found
        colnames.append(col.replace('\n', ' ').replace('-','').strip())   # Trim the header and remove '-'
    df.columns = colnames                                                 # Update the headers
    return df                                                             # Return the data frame

df = clean_colnames(df)                                                   # Execute the function

## ii) Clean columns 'State' & 'City'
df['State'] = df['State'].map(lambda x: x[:[m for m in re.compile('\d').finditer(x+'1')][0].start()])
df['City'] = df['City'].map(lambda x: x[:[m for m in re.compile('\d').finditer(x+'1')][0].start()])


########################
# Fill in empty header #
########################
df = df.rename(columns = {'Unnamed:':'Year'})


#################
# Export in csv #
#################
df.to_csv(r'C:\Prelim Semiannual Report to FIOU - Dec 14 2015\Table 4\crime data_processed.csv', index=None)