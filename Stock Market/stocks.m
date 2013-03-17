function stocks(nbuy, nsell, buybase, sellbase, learnrate, ndays, patient)

%    stocks(nbuy, nsell, buybase, sellbase, learnrate, ndays, patient)
%
%    Stage 0: This function creates a market in which there are nbuy buyers who
% value a product (the same product) at or below buybase by some percent
% (20% default), and nsell sellers who value the same product at or above
% sellbase (20% default). The buyers and sellers either have varying
% patience (patient = 0) or do not act on their patience (patient = 1). A
% patient seller is not concerned with how long he's been waiting to sell
% his product and thus does not decrease his sale price much with time.
% Buyers act similarly, except that patient buyers do not increase their
% buy price much with time.
%   Stage 1: The buyers and sellers "mingle" and enter bids with those
% agents that cause them to make a profit if a transaction occurs.
%   Stage 2: The sellers are randomly given an order in which they are
% allowed to make a transaction with a single buyer. The seller then
% randomly chooses which buyer he wants to sell to. Once a transaction has
% occured, that buyer is removed from that round and thus sellers can no
% longer choose to sell to him.
%   Stage 3: The total profits of the current round are summed - a buyer's
% profit is the difference between the value of the product to him and the
% sale price of the product, and a sellers profit is the difference between
% the value of the product to him and the buy price. The 2 agents with the
% greatest overall profit are used as examples for all other agents. The
% other agents' prices get closer to the best agents' prices with influence
% from the learnrate (this is actually updated at the beginning of the next
% part of the round).
%   Stage 4: Agents who have not transacted (?) are allowed to continue
% attempting to do so until either no more transactions are occurring or the
% round reaches 1000 iterations. At this point, the market is closed out 
% for the day. The average profit of the round is calculated along with the
% price variance for that round.
%   Stage 5: Steps 1-4 are repeated for ndays days and then the program
% stops. The daily average profits and daily price variances are plotted.
% ------------- Written by: Austin Milt (Oct 25, 2008) ----------
% ------------------ User Defined Variables ------------------ %
% nbuy      =   number of buyers
% nsell     =   number of sellers
% buybase   =   maximum value of product to buyers
% sellbase  =   minimum value of product to sellers
% learnrate =   rate at which agents learn to maximize profits (between 0
%                   and 1)
% ndays     =   number of days the market is run
% patient   =   if 0, agents prices approach their product value as time
%                   goes on. this is reset each day
%               if 1, agents prices are not influenced by time

% ------------------ Function Variables ------------------ %
% roundvariance =   variance (average of sell price and buy price variances)
%                        for each day
% roundavg      =   average profit of the market for each day
% M             =   market profit for that iteration of the round
% meanvariance  =   average variance of prices for each day
% buyvalue      =   value of the product to each buyer
% sellvalue     =   value of the product to each seller
% buypatience   =   patience of each buyer (between 0 and 1). a higher
%                       patience means less variability in buy price
% sellpatience  =   seller equivalent of buypatience
% buyprice      =   price each buyer is offering that iteration of that
%                       round
% sellprice     =   seller equivalent of buyprice
% bestbuy       =   buy price of buyer with the highest profit that
%                       iteration of the round
% bestsell      =   seller equivalent of bestbuy
% kk            =   current day (or round)
% boughtalready =   for each buyer, 1 if buyer hasnt made a transaction
%                       that round, 0 if he has
% soldalready   =   seller equivalent of boughtalready
% profit        =   profit of each transaction that takes place, where the
%                       first column is the profit, second column is the 
%                       buyer, third column is the seller
% ii            =   current iteration of the round (or day)
% bid           =   the profit that each buyer and seller pair will make if
%                       the profit is positive and they make a transaction
% b             =   current buyer
% s             =   current seller
% dumE          =   dummy variable with no meaning for this function
% order         =   vector of randomly chosen seller order
% seller        =   seller that gets to choose which buyer he sells to
% maytransact   =   buyers which seller has entered bids with
% buyind        =   index of buyer in maytransact which seller randomly
%                       chooses to sell to
% buyer         =   buyer to make a transaction with seller
% sortprofits   =   sorted (descending) version of proft
% bestbuyer     =   buyer with the maximum buyer/seller profit that
%                       iteration of that round
% bestseller    =   seller equivalent of bestbuyer
% AX            =   2x1 vector of y-axis handles for the end plot
% H1, H2        =   plot handles of end plots
% -------------------------------------------------------- %

%% Stage 0
%initialize variables
roundvariance = zeros(1,ndays);
roundavg = roundvariance;
M = zeros(1,1000);
meanvariance = M;
patient = logical(patient);

% set product values for each agent
buyvalue = (rand(1,nbuy)*(0.2) + 0.8).*ones(1,nbuy)*buybase;  % vary base price by 20% down
sellvalue = ones(1,nsell)*sellbase./((rand(1,nsell)*0.2 + 0.8)); %vary base price by 20% up

% set patience for each agent
buypatience = rand(1,nbuy);
sellpatience = rand(1,nsell);

% set initial best buy and best sell so that it doesnt effect their prices
buyprice = buyvalue;
sellprice = sellvalue;
bestbuy = buyprice;
bestsell = sellprice;

%% Stage 5 (encompasses Stage 1-4)
for kk = 1:ndays

    % reset some arrays each day
    boughtalready = ones(1,nbuy);
    soldalready = ones(1,nsell);
    profit = zeros(nsell,3);

    %% Stage 4 (encompasses Stage 1-3)
    for ii = 1:1000

        % reset the bids each iteration of the round
        bid = zeros(nbuy,nsell);
        %% Stage 1
        % update buy price and sell price
        if patient
            buyprice = (buyprice + learnrate*(bestbuy - buyprice));
            sellprice = (sellprice + learnrate*(bestsell - sellprice));
        else
            buyprice = (buyprice + learnrate*(bestbuy - buyprice)).*(1.0001 - exp(-ii./buypatience));
            sellprice = (sellprice + learnrate*(bestsell - sellprice))./(1.0001 - exp(-ii./sellpatience));
        end

        % let the agents mingle to decide if they want to enter bids
        for b = 1:nbuy
            if boughtalready(b) % if buyer has already made a transaction in this round, skip him
                for s = 1:nsell
                    if soldalready(s) % if seller has already made a transaction in this round, skip him
                        maysellprofit = buyprice(b) - sellvalue(s); % total profit to seller if he transacts with each buyer
                        maybuyprofit = buyvalue(b) - sellprice(s); % total profit to buyer if he transacts with each buyer
                        if maysellprofit > 0 && maybuyprofit > 0 % if they both profit, enter a bid
                            bid(b,s) = maysellprofit + maybuyprofit;
                        end
                    end
                end
            end
        end

        %% Stage 2
        % randomly decide which order sellers choose their buyer
        [dumE order] = sort(rand(1,nsell));

        % let every seller choose a buyer if there are any buyers to choose
        for j = 1:nsell
            seller = order(j);

            maytransact = find(bid(:,seller));
            if isempty(maytransact)
                continue
            end

            [dumE buyind] = sort(rand(1,length(maytransact))); % randomly choose an index from maytransact
            buyer = maytransact(buyind(1));
            profit(j,:) = [bid(buyer,seller) buyer seller];

            % remove agents from further transactions this round
            boughtalready(buyer) = 0;
            soldalready(seller) = 0;

        end

        if isempty(find(profit,1)) % then no transactions took place
            continue
        end

        %% Stage 3
        % teach all agents with an example from best
        % buyers and sellers. their new buyprices will update at the
        % beginning of the next round
        sortprofits = sortrows(profit,-1);
        bestbuyer = sortprofits(1,2);
        bestseller = sortprofits(1,3);

        bestbuy = buyprice(bestbuyer);
        bestsell = sellprice(bestseller);

        % determine the two diagnostic variables
        buyvariance = var(buyprice);
        sellvariance = var(sellprice);
        meanvariance(ii) = mean([buyvariance sellvariance]);
        M(ii) = sum(profit(:,1));

        if ii > 1 && M(ii-1) == M(ii) % then transactions have stopped
            M(ii:end) = [];
            meanvariance(ii:end) = [];
            break
        end
    end
    roundvariance(kk) = mean(meanvariance);
    roundavg(kk) = mean(M);

end

% plot the results
[AX H1 H2] = plotyy(1:kk,roundavg(1:kk),1:kk,roundvariance(1:kk));
set(get(AX(1),'YLabel'),'String','Daily Average Profit ($)');
set(get(AX(2),'Ylabel'),'String','Daily Average Variance ($)');
xlabel('Market Day (or Round)');

