import sys
import json

print(sys.version)

def get_json_data(file_name):
    with open(file_name) as file:
        data = json.load(file)
    return data

def avoid_these_places(venue: str,reason: str,user: str)-> None:
    if venue in [x["name"] for x in places_to_avoid]:
        for k in places_to_avoid:
            if k['name'] == venue:
                k['reason'].append(f"There is nothing for {user} to {reason}.")
    else:
        venue_to_add={}
        venue_to_add["name"]=venue
        venue_to_add["reason"]=[f"There is nothing for {user} to {reason}."]
        places_to_avoid.append(venue_to_add)  
        places_to_go.remove(venue)
    
    return


def check_venues_for_food_drink(user: str,wont_eat: list,drinks: list,venues: list) -> None:    
    good_for_food = set()
    good_for_drinks = set()
    
    #upper_case
    drinks =[i.upper() for i in drinks]
    wont_eat =[i.upper() for i in wont_eat]

    for venue in venues:        
        for food_available in venue['food']:
            if venue['name'] not in good_for_food and food_available.upper() not in wont_eat:
                good_for_food.add(venue['name'])                
               
        if venue['name'] not in good_for_food: 
            avoid_these_places(venue['name'],"eat",user)
        
        for drinks_at_venue in venue['drinks']:
            if venue['name'] not in good_for_drinks and drinks_at_venue.upper() in drinks:
                good_for_drinks.add(venue['name'])            
        
        if venue['name'] not in good_for_drinks: 
            avoid_these_places(venue['name'],"drink",user)
    
    return
    
if __name__ == "__main__":

    users_file = "data/users.json"
    venues_file = "data/venues.json"

    users = get_json_data(users_file)
    venues = get_json_data(venues_file)

    places_to_go = set()
    places_to_avoid=[]
    places_to_go_and_avoid={}


# Get List of Venues
    [places_to_go.add(venue['name']) for venue in venues]

#check which venue is good to go and which needs to be avoided for each user
    for user in users:
        check_venues_for_food_drink(user['name'],user['wont_eat'],user['drinks'],venues)
    
    places_to_go_and_avoid["places_to_visit"]=list(places_to_go)
    places_to_go_and_avoid["places_to_avoid"]=places_to_avoid
    places_to_go_and_json = json.dumps(places_to_go_and_avoid, indent=2)
    print(places_to_go_and_json)
    


