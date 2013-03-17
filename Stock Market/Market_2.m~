function output = Market_2(input)
% [market_eff market_price trans_record]

%% Set variables for market based on inputs
T=input.T(1); del_T=input.T(2); %% Time, iteration information
if isempty(input.N),N=length(input.buy_value); %% Number of agents
else,N=input.N;end
%% Setting or getting personality parameters
if isempty(input.buy_value)
    base=input.price_info(1); 
    range=input.price_info(2); 
    spread=input.price_info(3);
    buy_value=ones(1,N).*base+(rand(1,N)-.4*ones(1,N)).*...
        range+.5*spread.*ones(1,N); %% Assign value of product to buyers
    sell_value=ones(1,N).*base+(rand(1,N)-.6*ones(1,N)).*...
        range-.5*spread.*ones(1,N); %% Assign value of product to sellers
else,buy_value=input.buy_value; sell_value=input.sell_value;end
if isempty(input.buy_patience)
    %% Set buyer and seller patiences, 'normalized' to max market run time
    buy_patience = rand(1,N)*T; sell_patience = rand(1,N)*T;
else, buy_patience=input.buy_patience; sell_patience=input.sell_patience;end

%% This bit finds the optimum number of buyers, sellers in the market based
%% on how everyone values the product being exchanged.  If the sorted
%% vectors were plotted, 'keep' would be the quantity of the good at the
%% intersection of the two lines.  The price at this intersection would be
%% the market price for the good.  Since this is a discrete system, the
%% market price is defined as the mean of the buy and sell value for the
%% 'last' buyer and seller.
dumm_sell=sort(sell_value,'ascend'); dumm_buy=sort(buy_value,'descend');
%% Plot of supply and demand curves
% plot(1:N,dumm_sell,1:N,dumm_buy)
%% Determining optimum ## transactions
for ii=N:-1:1
j=length(find(dumm_sell<dumm_buy(ii)));
if j>=ii,keep=j;,break;end
end
%% Calculate maximum profit from optimum number of buyers and sellers
keep=max(length(dumm_sell(dumm_sell<=dumm_buy(keep))),...
    length(dumm_buy(dumm_buy>=dumm_sell(keep))));
profit_max=sum(dumm_buy(1:keep))-sum(dumm_sell(1:keep));
%% Calculate market price of good based on how people value good
market_price=mean([dumm_buy(keep),dumm_sell(keep)]);


itr=ceil(T/del_T); %% Set number of itterations given T, del_T
buy_indx=1:N; %% Buyers index
sell_indx=1:N; %% Sellers index
buy_price=buy_value*.5; %% Each wants to make a lot of profit...
sell_price=sell_value*2;
profit=0;
T=0;
%% Initialize variables
trans_record=[];
current=[];
current_2=[];
buy=0;
sell=0;
count=0;
%fig=figure;
for i=1:itr
    T=T+del_T; %% Update time step
    max_buy=max(buy_price(buy_indx)); %% Max buying price
    min_sell=min(sell_price(sell_indx)); %% Min selling price
    buyers=find(buy_price(buy_indx)>=min_sell);
    buyers=buy_indx(buyers); 
    %% If not offering more than min, remove
    sellers=find(sell_price(sell_indx)<=max_buy);
    sellers=sell_indx(sellers); 
    %% If asking more than max, remove
    
    temp_indx=[buyers,sellers+N]; 
    %% All making transaction in one indx, maps onto indx
    temp_indx(randperm(length(temp_indx)))=temp_indx; 
    %% Set bidding order & put temp_indx in bidding order
    if ~isempty(temp_indx),count=count+1;end 
    %% Records the number of successful transaction periods
    temp_trans_record=[]; 
    %% Initiating temporary transaction record for updating market bids

    while length(temp_indx)>1 & max(temp_indx)>N & min(temp_indx)<=N
        
        current=temp_indx(1); %% Since temp_indx is in the bidding order, take first entry 
        
        if current<=N %% Buyer condition, buyer advantage
            temp=temp_indx(temp_indx>N); %% Take away buyers in temp_indx
            %% Find first instance in temp_indx where sell price is less
            %% than or equal to what current buyer is willing to pay
            current_2=temp(find(sell_price(temp-N)<=buy_price(current),1))-N; 
            if ~isempty(current_2)
                sell=sell+1;
                %% Set transaction price to whatever seller is willing to
                %% sell for
                record=[sell_price(current_2),current,current_2 T];
                %% Remove nodes from temp_indx so they are not reused
                temp_indx(temp_indx==current_2+N)=[];
                %% Clear buyer from both indexes
                buyers(find(buyers==current))=[]; 
                buy_indx(find(buy_indx==current))=[];
                %% Clear seller from both indexes
                sellers(find(sellers==current_2))=[]; sell_indx(find(sell_indx==current_2))=[];
                %% Update market profit
                add_profit=abs(buy_value(current)-record(1))+...
                           abs(sell_value(current_2)-record(1));
            end
            
        else %% Seller condition, seller advantage
            current=current-N; %% Adjust variable value from temp_indx list
            temp=temp_indx(temp_indx<=N); %% Take away other sellers from temp_indx
            %% Find first instance in temp_indx where buy price is greater
            %% than or equal to what current seller is willing to pay
            current_2=temp(find(buy_price(temp)>=sell_price(current),1));
            if ~isempty(current_2);
                buy=buy+1;
                %% Set transaction price to whatver buyer is willing to pay
                record=[buy_price(current_2),current_2,current T];
                %% Remove nodes from temp_indx so they are not reused
                temp_indx(temp_indx==current_2)=[];
                %% Clear buyer from both indexes
                buyers(find(buyers==current_2))=[]; 
                buy_indx(find(buy_indx==current_2))=[];
                %% Clear seller from both indexes
                sellers(find(sellers==current))=[];
                sell_indx(find(sell_indx==current))=[];
                %% Update market profit
                add_profit=abs(buy_value(current_2)-record(1))+...
                           abs(sell_value(current)-record(1));
            end
        end
        if ~isempty(current_2) %% Transaction takes place
            %% Update transaction price record
            temp_trans_record=[temp_trans_record; record];
            profit=profit+add_profit; %% Update profit
        end
        %% Clear 'current' variables, temp_indx ref
        current=[];current_2=[];temp_indx(1)=[];
    end
    buy_energy=T./buy_patience; sell_energy=T./sell_patience;
    %% To update, or not to update?
    buy_logic=(rand(size(buy_patience))>=exp(-buy_energy));
    sell_logic=(rand(size(sell_patience))>=exp(-sell_energy));
    %% Update buyers, sellers offering prices differently if no
    %% transactions took place in the last bidding session
    buy_price=min([...
                   buy_value',...
                   (buy_price+buy_logic.*(mean(sell_price(sell_price<9999))-buy_price)...
                    .*abs(rand(1,N)-.12))'... 
                    %% This compensates for descrepencies in i'm not 
                    %% sure what, but something reulting in a tendency
                    %% for buyers to shift their offering prices to
                    %% what they value the product at faster than
                    %% sellers
                   ]');

    sell_price=max([...
                    sell_value',...
                   (sell_price-sell_logic.*(sell_price-mean(buy_price(buy_price>0)))...
                    .*rand(1,N))'...
                   ]');
               
    %% Null / void buyers, sellers that have already make transactions
    buy_price(setxor(1:N,buy_indx))=-9999;
    sell_price(setxor(1:N,sell_indx))=9999;
    %% Update transaction record
    trans_record=[trans_record; temp_trans_record];
    %% End the market run if no more buyers or no more sellers    
    if isempty(buy_indx) | isempty(sell_indx) | ~(min(sell_value(sell_indx))<=max(buy_value(buy_indx))),break,end
end
market_eff=profit/profit_max; %% Calculate market efficiency
%% Plot prices of all transactions that occured in the order they occured
 plot(1:length(trans_record),trans_record(:,1), 'LineStyle', 'none', 'Marker','.','MarkerSize',14)
%% Plot supply, demand curves of those agents who did not make
%% transactions
dumm_buy=buy_value(buy_indx); dumm_sell=sell_value(sell_indx);
dumm_buy=sort(dumm_buy,'descend'); dumm_sell=sort(dumm_sell);
% fig=figure;
% plot(1:length(dumm_sell),dumm_sell,1:length(dumm_buy),dumm_buy);

%% Setting output variable
output.stuff=[min(sell_price(sell_indx)) max(buy_price(buy_indx)) keep count buy sell market_eff];
output.N=N; output.buy_value=buy_value; output.sell_value=sell_value;
output.buy_patience=buy_patience; output.sell_patience=sell_patience;
output.trans_record=trans_record;

        