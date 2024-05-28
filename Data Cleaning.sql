/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Data Cleaning Potfolio].[dbo].['Nashvilla Housing Data for Data$']

  /*

  Cleaning Data in SQL

  */

  select * from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']


  -- Standardise Data Format

  
  alter table [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
  add converted_date date;

  update [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
  Set converted_date = CONVERT (date , SaleDate)

  select converted_date from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']

  alter table [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
  drop column converted_date


  --Populate property address data

  select * 
  from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']

 -- Where propertyaddress is null
 order by ParcelID


 select A.ParcelID , A.PropertyAddress, B.ParcelID, B.PropertyAddress , ISNULL(B.PropertyAddress,A.PropertyAddress)
 from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$'] A
 join [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$'] B
 on A.ParcelID = B.ParcelID 
 and A.[UniqueID ] <> B.[UniqueID ]
 where B.PropertyAddress is null


 update B 
 set PropertyAddress = ISNULL(B.PropertyAddress,A.PropertyAddress)
 from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$'] A
 join [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$'] B
 on A.ParcelID = B.ParcelID 
 and A.[UniqueID ] <> B.[UniqueID ]

 select * from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']

 --Where PropertyAddress is null

 --Breaking out Address individual columns(Address,city,state)


 select PropertyAddress
 from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']

 --select
 --SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as New_Address, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as city 
 --from ['Nashvilla Housing Data for Data$']

 -- select
 --SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)) as new_address
 --from ['Nashvilla Housing Data for Data$']

 alter table [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
 add new_address nvarchar(255); 

 update [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
 set new_address = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

 alter table ['Nashvilla Housing Data for Data$']
 add city nvarchar(255); 

 update [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
 set city = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) 

 select * from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']


 --Spliting of Owner Address

 select OwnerAddress
 from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']

 --select 
 --PARSENAME(replace(OwnerAddress , ',' , '.'), 3)

 --from ['Nashvilla Housing Data for Data$']

 alter table [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
 add owersplitaddress Nvarchar(255);
 
 alter table [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
 add ownersplitcity Nvarchar(255);
 
 alter table [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
 add ownersplitstate Nvarchar(255);

 update [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
 set owersplitaddress = PARSENAME(replace(OwnerAddress , ',' , '.'), 3)
 from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']

 update [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
 set ownersplitcity = PARSENAME(replace(OwnerAddress , ',' , '.'), 2)

 update [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
 set ownersplitstate = PARSENAME(replace(OwnerAddress , ',' , '.'), 1)

 
 
 select *
 from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']


 -- Change Y and N to Yes and No in 'sold as vacant' field

 select distinct(SoldAsVacant)
 from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']

 select SoldAsVacant , 
 case when SoldAsVacant = 'Y' then 'Yes' 
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end
 from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']

 update [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
 set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes' 
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end

 select distinct(SoldAsVacant), count(SoldAsVacant)
 from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
 group by SoldAsVacant



 --Remove duplicates

 --select * , 
 --ROW_NUMBER() over( partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference Order By UniqueID) as Row_No
 --from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']

 -- Creating CTE

 WITH RowNumberCTE AS(
 select * , 
 ROW_NUMBER() over( partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference Order By UniqueID) as Row_No
 from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
 )
 delete from RowNumberCTE
 where Row_No > 1

 select * from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']

-- Delete Unused Columnes

select *
from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']

alter table [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']
drop column SaleDate

select *
from [Data Cleaning Potfolio]..['Nashvilla Housing Data for Data$']