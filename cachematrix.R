## Bacause matrix inversion is usually a costly computation, 
## caching the inverse of a matrix rather can be benificial to computing
## it repeatedly. These functions (belonging to the Week 3 programming 
## assignment of course "R Programming") aim at cache the inverse of a matrix.

## This function creates a special "matrix" object that can cache its inverse.

makeCacheMatrix <- function(x = matrix()) { ## define the argument with default mode of "matrix"
  value_of_inverse <- NULL                ## create value_of_inverse object to hold the matrix inverse value, start at "null"
  set <- function(y) {                    ## create set object to hold function  
    x <<- y                             ## assigns new matrix value to the parent environment "x"
    value_of_inverse <<- NULL           ##  reset value_of_inverse to "NULL"
  }
  
  get <- function() x                     ## define the get fucntion - returns value of the matrix argument
  
  setinverse <- function(inverse) value_of_inverse <<- inverse  ## assigns value of the value_of_inverse in parent environment
  getinverse <- function() value_of_inverse                     ## gets the value of inv where called
  list(set = set, get = get, setinverse = setinverse, getinverse = getinverse)  ## create list
}

## This function computes the inverse of the special "matrix" returned by makeCacheMatrix above. 
## If the inverse has already been calculated (and the matrix has not changed),
## then the cachesolve retrieves the inverse from the cache.
## The inverse of the square matrix is calculated with the solve function in R. 
## For example, if X is a square invertible matrix, then solve(X) returns its inverse.


## Return a matrix that is the inverse of 'x'
cacheSolve <- function(x, ...) {
  value_of_inverse <- x[4]()          ## get the inverse value from the list x attribuet "getinverse"
  if(!is.null(value_of_inverse)) {    ## if the value_of_inverse is not null  
    message("getting cached data")    ## then print message "geting cached data"
    return(value_of_inverse)          ## else return final argument in function: return the value_of_inverse
  }
  data <- x[2]()                      ## get the inverse value from the list x attribute "get"
  value_of_inverse <- solve(data, ...)## calculate the inverse of the value and store it in object value_of_inverse
  x[3](value_of_inverse)              ## set the value to "value_of_inverse"
  value_of_inverse                    ## final argument in function: return the value_of_inverse

}