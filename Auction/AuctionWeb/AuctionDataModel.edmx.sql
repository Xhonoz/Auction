
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 11/20/2018 20:28:06
-- Generated from EDMX file: E:\kode\Auction\AuctionWeb\AuctionDataModel.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [aspnet-AuctionWeb-20181031110113];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_ProfileProduct]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ProductSet] DROP CONSTRAINT [FK_ProfileProduct];
GO
IF OBJECT_ID(N'[dbo].[FK_ProductProfile]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ProductSet] DROP CONSTRAINT [FK_ProductProfile];
GO
IF OBJECT_ID(N'[dbo].[FK_ProfileBid]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[BidSet] DROP CONSTRAINT [FK_ProfileBid];
GO
IF OBJECT_ID(N'[dbo].[FK_ProductBid]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[BidSet] DROP CONSTRAINT [FK_ProductBid];
GO
IF OBJECT_ID(N'[dbo].[FK_ProfileRating]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[RatingSet] DROP CONSTRAINT [FK_ProfileRating];
GO
IF OBJECT_ID(N'[dbo].[FK_RatingProduct]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[RatingSet] DROP CONSTRAINT [FK_RatingProduct];
GO
IF OBJECT_ID(N'[dbo].[FK_PictureProduct]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[PictureSet] DROP CONSTRAINT [FK_PictureProduct];
GO
IF OBJECT_ID(N'[dbo].[FK_ProductFeatures_Product]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ProductFeatures] DROP CONSTRAINT [FK_ProductFeatures_Product];
GO
IF OBJECT_ID(N'[dbo].[FK_ProductFeatures_Features]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ProductFeatures] DROP CONSTRAINT [FK_ProductFeatures_Features];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[ProfileSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ProfileSet];
GO
IF OBJECT_ID(N'[dbo].[ProductSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ProductSet];
GO
IF OBJECT_ID(N'[dbo].[BidSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[BidSet];
GO
IF OBJECT_ID(N'[dbo].[RatingSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[RatingSet];
GO
IF OBJECT_ID(N'[dbo].[PictureSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[PictureSet];
GO
IF OBJECT_ID(N'[dbo].[FeaturesSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[FeaturesSet];
GO
IF OBJECT_ID(N'[dbo].[ProductFeatures]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ProductFeatures];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'ProfileSet'
CREATE TABLE [dbo].[ProfileSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [email] nvarchar(max)  NOT NULL,
    [fName] nvarchar(max)  NOT NULL,
    [lName] nvarchar(max)  NOT NULL,
    [phone] int  NOT NULL
);
GO

-- Creating table 'ProductSet'
CREATE TABLE [dbo].[ProductSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [name] nvarchar(max)  NOT NULL,
    [description] nvarchar(max)  NOT NULL,
    [endtime] datetime  NOT NULL,
    [active] bit  NOT NULL,
    [buyer_Id] int  NULL,
    [profile_Id] int  NOT NULL
);
GO

-- Creating table 'BidSet'
CREATE TABLE [dbo].[BidSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [amount] int  NOT NULL,
    [profile_Id] int  NOT NULL,
    [product_Id] int  NOT NULL
);
GO

-- Creating table 'RatingSet'
CREATE TABLE [dbo].[RatingSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [score] int  NOT NULL,
    [comment] nvarchar(max)  NOT NULL,
    [Author_Id] int  NOT NULL,
    [Product_Id] int  NOT NULL
);
GO

-- Creating table 'PictureSet'
CREATE TABLE [dbo].[PictureSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [path] nvarchar(max)  NOT NULL,
    [title] nvarchar(max)  NOT NULL,
    [Product_Id] int  NOT NULL
);
GO

-- Creating table 'FeaturesSet'
CREATE TABLE [dbo].[FeaturesSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [description] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'ProductFeatures'
CREATE TABLE [dbo].[ProductFeatures] (
    [Product_Id] int  NOT NULL,
    [Features_Id] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'ProfileSet'
ALTER TABLE [dbo].[ProfileSet]
ADD CONSTRAINT [PK_ProfileSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'ProductSet'
ALTER TABLE [dbo].[ProductSet]
ADD CONSTRAINT [PK_ProductSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'BidSet'
ALTER TABLE [dbo].[BidSet]
ADD CONSTRAINT [PK_BidSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'RatingSet'
ALTER TABLE [dbo].[RatingSet]
ADD CONSTRAINT [PK_RatingSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'PictureSet'
ALTER TABLE [dbo].[PictureSet]
ADD CONSTRAINT [PK_PictureSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'FeaturesSet'
ALTER TABLE [dbo].[FeaturesSet]
ADD CONSTRAINT [PK_FeaturesSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Product_Id], [Features_Id] in table 'ProductFeatures'
ALTER TABLE [dbo].[ProductFeatures]
ADD CONSTRAINT [PK_ProductFeatures]
    PRIMARY KEY CLUSTERED ([Product_Id], [Features_Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [buyer_Id] in table 'ProductSet'
ALTER TABLE [dbo].[ProductSet]
ADD CONSTRAINT [FK_ProfileProduct]
    FOREIGN KEY ([buyer_Id])
    REFERENCES [dbo].[ProfileSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ProfileProduct'
CREATE INDEX [IX_FK_ProfileProduct]
ON [dbo].[ProductSet]
    ([buyer_Id]);
GO

-- Creating foreign key on [profile_Id] in table 'ProductSet'
ALTER TABLE [dbo].[ProductSet]
ADD CONSTRAINT [FK_ProductProfile]
    FOREIGN KEY ([profile_Id])
    REFERENCES [dbo].[ProfileSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ProductProfile'
CREATE INDEX [IX_FK_ProductProfile]
ON [dbo].[ProductSet]
    ([profile_Id]);
GO

-- Creating foreign key on [profile_Id] in table 'BidSet'
ALTER TABLE [dbo].[BidSet]
ADD CONSTRAINT [FK_ProfileBid]
    FOREIGN KEY ([profile_Id])
    REFERENCES [dbo].[ProfileSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ProfileBid'
CREATE INDEX [IX_FK_ProfileBid]
ON [dbo].[BidSet]
    ([profile_Id]);
GO

-- Creating foreign key on [product_Id] in table 'BidSet'
ALTER TABLE [dbo].[BidSet]
ADD CONSTRAINT [FK_ProductBid]
    FOREIGN KEY ([product_Id])
    REFERENCES [dbo].[ProductSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ProductBid'
CREATE INDEX [IX_FK_ProductBid]
ON [dbo].[BidSet]
    ([product_Id]);
GO

-- Creating foreign key on [Author_Id] in table 'RatingSet'
ALTER TABLE [dbo].[RatingSet]
ADD CONSTRAINT [FK_ProfileRating]
    FOREIGN KEY ([Author_Id])
    REFERENCES [dbo].[ProfileSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ProfileRating'
CREATE INDEX [IX_FK_ProfileRating]
ON [dbo].[RatingSet]
    ([Author_Id]);
GO

-- Creating foreign key on [Product_Id] in table 'RatingSet'
ALTER TABLE [dbo].[RatingSet]
ADD CONSTRAINT [FK_RatingProduct]
    FOREIGN KEY ([Product_Id])
    REFERENCES [dbo].[ProductSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_RatingProduct'
CREATE INDEX [IX_FK_RatingProduct]
ON [dbo].[RatingSet]
    ([Product_Id]);
GO

-- Creating foreign key on [Product_Id] in table 'PictureSet'
ALTER TABLE [dbo].[PictureSet]
ADD CONSTRAINT [FK_PictureProduct]
    FOREIGN KEY ([Product_Id])
    REFERENCES [dbo].[ProductSet]
        ([Id])
    ON DELETE CASCADE ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_PictureProduct'
CREATE INDEX [IX_FK_PictureProduct]
ON [dbo].[PictureSet]
    ([Product_Id]);
GO

-- Creating foreign key on [Product_Id] in table 'ProductFeatures'
ALTER TABLE [dbo].[ProductFeatures]
ADD CONSTRAINT [FK_ProductFeatures_Product]
    FOREIGN KEY ([Product_Id])
    REFERENCES [dbo].[ProductSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [Features_Id] in table 'ProductFeatures'
ALTER TABLE [dbo].[ProductFeatures]
ADD CONSTRAINT [FK_ProductFeatures_Features]
    FOREIGN KEY ([Features_Id])
    REFERENCES [dbo].[FeaturesSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ProductFeatures_Features'
CREATE INDEX [IX_FK_ProductFeatures_Features]
ON [dbo].[ProductFeatures]
    ([Features_Id]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------