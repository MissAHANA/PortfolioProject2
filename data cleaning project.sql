/*
Cleaning Data in SQL Queries
*/
SELECT *
FROM [PortfolioProject].[dbo].NashvilleHousing

-- Standardize Date Format
SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM [PortfolioProject].[dbo].NashvilleHousing
UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER Table  NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--Populate Property Address Data
SELECT*
FROM [PortfolioProject].[dbo].NashvilleHousing
--WHERE PropertyAddress is NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [PortfolioProject].[dbo].NashvilleHousing a
JOIN [PortfolioProject].[dbo].NashvilleHousing b
  ON a.ParcelID= b.ParcelID
  AND a.[UniqueID]<>b.[UniqueID]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [PortfolioProject].[dbo].NashvilleHousing a
JOIN [PortfolioProject].[dbo].NashvilleHousing b
  ON a.ParcelID= b.ParcelID
  AND a.[UniqueID]<>b.[UniqueID]
WHERE a.PropertyAddress is null

-- Breaking out Address into Individual Columns (ADDRESS,CITY,STATE)

SELECT PropertyAddress
FROM [PortfolioProject].[dbo].NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address

FROM [PortfolioProject].[dbo].NashvilleHousing

ALTER Table  NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 


ALTER Table  NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 

SELECT *
FROM [PortfolioProject].[dbo].NashvilleHousing

SELECT OwnerAddress
FROM [PortfolioProject].[dbo].NashvilleHousing
--WHERE OwnerAddress is NOT NULL

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM [PortfolioProject].[dbo].NashvilleHousing
WHERE OwnerAddress is not null


ALTER Table  NashvilleHousing
ADD OwnerSplitAddress  nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress  = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER Table  NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER Table  NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT*
FROM [PortfolioProject].[dbo].NashvilleHousing


-- Change Y and N to YES and NO in "SOLD as Vacant" Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [PortfolioProject].[dbo].NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant ='N'  THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM [PortfolioProject].[dbo].NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant=CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant ='N'  THEN 'NO'
	   ELSE SoldAsVacant
	   END

-- delete unused columns

SELECT*
FROM [PortfolioProject].[dbo].NashvilleHousing

ALTER TABLE [PortfolioProject].[dbo].NashvilleHousing
DROP COLUMN SaleDate
