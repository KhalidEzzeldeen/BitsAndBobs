"""
##################################################################################
Usage: "python3 synccopy.py dirSource dirSink mode
i.e. python3 synccopy.py /Users/sinn/Desktop/Data /Volumes/ESTELLA/Data 0
Syncs dirSink with dirSource; that is, dirSink becomes a backup of dirSource.If
dirSink does not exist, it will be created as a direct copy of dirSource.  Else,
the created __index.mfe will be used to determine which files have been modified
and/or added in dirSource since the last Sync, and these files will be updated in
dirSink.  This file is meant as a preliminary file for a more comprehensive Sync
code.
##################################################################################
"""

import os, sys, time
maxfileload = 1000000
blksize = 1024 * 500


def copyfile(pathFrom, pathTo, maxfileload=maxfileload):
    """
    Copy one file pathFrom to pathTo, byte for byte;
    uses binary file modes to supress Unicode decode and endline transform;
    Original / modified from "Programming Python" 4th Ed 2011, Mark Lutz
    """

    if os.path.getsize(pathFrom) <= maxfileload:
        bytesFrom = open(pathFrom, 'rb').read()     # read small file all at once
        open(pathTo, 'wb').write(bytesFrom)
    else:
        fileFrom = open(pathFrom, 'rb')             # read big file in chunks
        fileTo = open(pathTo, 'wb')                 # need 'b' mode for both
        while True:
            bytesFrom = fileFrom.read(maxfileload)  # get one block, less at end
            if not bytesFrom: break                 # empty after last chunk
            fileTo.write(bytesFrom)


def updatedir(sourceDir, sinkDir, lastSync, mode,\
              verbose=0, sourceFiles=None, sinkFiles=None):
    """
    Checks for files to update / add to sinkDir from sourceDir;
    If file already exists, checks to see if it is most current version;
    If file does not exist, creates file in sinkDir;
    Uses lastsync to see if files in sourceDir have been modified since last update;
    Run with no lastsync variable input to copy over all files;
    Portions inspired / borrowed from "Programming Python" 4th Ed 2011, Mark Lutz
    """
    fcountN = fcountU = dcountN = dcountU = 0
    print('Updating', sinkDir, 'with', sourceDir)
    sourceFiles = os.listdir(sourceDir) if sourceFiles is None else sourceFiles
    sinkFiles = os.listdir(sinkDir) if sinkFiles is None else sinkFiles
    # mode==0 acts like 1st sync (i.e. a copying)
    newFiles = sourceFiles if mode==0 else difference(sourceFiles, sinkFiles)
    oldFiles = [] if mode==0 else intersect(sourceFiles, sinkFiles)

    # these two processes could be combined here, but I think I will need to
    # split them for the extension
    # copy over new first
    if verbose > 1: print('Copying new files to', sinkDir)
    for filename in newFiles:
        pathFrom = os.path.join(sourceDir, filename)
        pathTo = os.path.join(sinkDir, filename)
        # copy files, not directories
        if not os.path.isdir(pathFrom):
            try:
                if verbose > 1: print('Copying', pathFrom, 'to', pathTo)
                copyfile(pathFrom, pathTo)
                fcountN +=1
            except:
                print('Error copying', pathFrom, 'to', pathTo, '--skipped')
                print(sys.exc_info()[0], sys.exc_info()[1])

    # update old file next
    if verbose > 1: print('Updating old files in', sinkDir)
    for filename in oldFiles:
        pathFrom = os.path.join(sourceDir, filename)
        pathTo = os.path.join(sinkDir, filename)
        # update files only if they have been modified
        if not os.path.isdir(pathFrom) and os.path.getmtime(pathFrom) > lastSync:
            try:
                if verbose > 1: print('Copying', pathFrom, 'to', pathTo)
                copyfile(pathFrom, pathTo)
                fcountU +=1
            except:
                print('Error copying', pathFrom, 'to', pathTo, '--skipped')
                print(sys.exc_info()[0], sys.exc_info()[1])

    # create new directories, update old directories
    if verbose > 1: print('Updating directories in', sinkDir)
    for filename in sourceFiles:
        pathFrom = os.path.join(sourceDir, filename)
        pathTo = os.path.join(sinkDir, filename)
        # update / create directories
        if os.path.isdir(pathFrom):
            if verbose: print('updating dir', pathFrom, 'in', pathTo)
            try:
                if not os.path.exists(pathTo):
                    try:
                        # make new subdir if it does not exist
                        if verbose > 1: print('creating new dir', pathTo)
                        os.mkdir(pathTo)
                        dcountN += 1
                    except:
                        print('Error creating', pathTo, '--skipped')
                        print(sys.exc_info()[0], sys.exc_info()[1])
                else: dcountU += 1
                # recur into subdirs
                below = updatedir(pathFrom, pathTo, lastSync, mode)
                fcountN += below[0]
                fcountU += below[1]
                dcountN += below[2]
                dcountU += below[3]
            except:
                print('Error populating / updating', pathTo, '--skipped')
                print(sys.exc_info()[0], sys.exc_info()[1])

    return (fcountN, fcountU, dcountN, dcountU)


def intersect(seq1, seq2):
    """
    Return all items in both seq1, seq2;
    use of set does not maintain order encountered.
    Original / modified from "Programming Python" 4th Ed 2011, Mark Lutz
    """
    return [item for item in seq1 if item in seq2]


def difference(seq1, seq2):
    """
    Return all items in seq1 not in seq2;
    use of set does not maintain order encountered.
    Original / modified from "Programming Python" 4th Ed 2011, Mark Lutz
    """
    return [item for item in seq1 if item not in seq2]


def getargs():
    """
    Get and verify directory name arguments, mode argument, returns default
    None on errors
    Portions inspired / borrowed from "Programming Python" 4th Ed 2011, Mark Lutz
    """
    try:
        sourceDir, sinkDir, mode = sys.argv[1:]
    except:
        print('Usage error: synccopy.py sourceDir sinkDir mode')
    else:
        if not os.path.isdir(sourceDir):
            print('Error: sourceDir is not a directory')
        elif not os.path.exists(sinkDir):
            os.mkdir(sinkDir)
            print('Note: sinkDir was created')
            createindex(sourceDir, sinkDir, ('date',))
            return (sourceDir, sinkDir, 0.0, 0)
        else:
            print('sinkDir exists; retrieving last sync date')
            params = getindex(sourceDir, sinkDir, ('date',), mode)
            if params:
                return (sourceDir, sinkDir, params[0], params[1])


def getindex(sourceDir, sinkDir, args, mode):
    """
    Get information from previous Syncs via index file;
    index file, for now, resides in sinkDir
    args in this case only consists of dates paired w/ sourcedir;
    will expand to further args in comprehensive sync
    """
    indexpath = os.path.join(sinkDir, '__index.mfe')
    try:
        dates = eval(open(str(indexpath), 'r').read())
        if 'date' in args:
            try:
                date = dates[sourceDir]
                return (date, mode)
            except KeyError:
                print(sinkDir, 'has not been synced with', sourceDir, 'previously')
                updateindex(sourceDir, sinkDir, ('date',))
                return (0.0, 0)
        else:
            return (0.0, mode)
    except:
        print('Error reading index file in', sinkDir)
        newFile = input('Create new index file and assume 1st Sync? Y/N? ')
        if newFile in ['y', 'Y']:
            createindex(sourceDir, sinkDir, ('date',))
            return (0.0, 0)
        else:
            print('Terminating Sync')


def createindex(sourceDir, sinkDir, args):
    """
    creates / overwrites index file in sinkDir with args prvided;
    index is (currently) a dictionary of 
    """
    indexpath = os.path.join(sinkDir, '__index.mfe')
    if 'date' in args:
        dates = {sourceDir:0.0}
    open(indexpath, 'w').write(str(dates))


def updateindex(sourceDir, sinkDir, args):
    """
    updates index in sinkDir for args provided;
    if no index exists, creates one
    """
    indexpath = os.path.join(sinkDir, '__index.mfe')
    restarttext = ('Create new index and assume 1st sync between\n',\
              sourceDir, 'and', sinkDir, '? ')
    
    if os.path.exists(indexpath):
        try:
            dates = eval(open(str(indexpath), 'r').read())
            if 'date' in args:
                dates[sourceDir] = time.time()
            open(indexpath, 'w').write(str(dates))
                    
        except:
            print('Error with opening index')
            print(*restarttext, end=' ')
            newFile = input()
            if newFile in ['y', 'Y']:
                createindex(sourceDir, sinkDir, ('date',))
            else: print('Index not updated')

    else:
        print('No index in', sinkDir)
        print(*restarttext, end=' ')
        newFile = input()
        if newFile in ['y', 'Y']:
            createindex(sourceDir, sinkDir, ('date',))
        else: print('Index not updated')


if __name__=='__main__':
    """
    Original / modified from "Programming Python" 4th Ed 2011, Mark Lutz
    """
    argstuple = getargs()
    if argstuple:
        print('Syncing...')
        start = time.clock()
        fcountN, fcountU, dcountN, dcountU = \
                 updatedir(*argstuple)
        updateindex(argstuple[0], argstuple[1], ('date',))
        print('Updated', fcountU, 'files,', dcountU, 'directories and', end=' ')
        print('copied', fcountN, 'new files,', dcountN, 'new directories')
        print('in', time.clock() - start, 'mins')
